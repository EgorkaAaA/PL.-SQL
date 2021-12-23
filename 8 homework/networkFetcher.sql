create or replace type lebedev_eg.t_fetch_header as object (
    name varchar2(50),
    value varchar2(100)
);

create or replace type lebedev_eg.t_arr_fetch_header as table of lebedev_eg.t_fetch_header;

create or replace function lebedev_eg.http_fetch
(
    p_url varchar2, --url запроса
    p_method varchar2 default 'get', --метод запроса
    p_secure boolean default false, --использовать ли https
    --p_https_host varchar2 default null,
    p_headers lebedev_eg.t_arr_fetch_header default null, --заголовки запроса
    p_body clob default null, --тело запроса
    p_charset varchar2 default 'utf-8', --кодировка тела запроса
    p_timeout number default 60, --время таймаута соединения в секундах
    p_encoding varchar2 default null, --режим сжатия
    p_executor varchar2 default 'anonymous block', --информация о вызывающей программе (зачем?)
    p_debug boolean default false, --режим отладки
    out_success out boolean, --флаг успеха запроса
    out_code out number --конкретный код ответа на запрос
)
return clob --возвращает ответ в текстовом виде
as
    --служебные varchar2 строчки для форматирования дебаг вывода
    c_debug_delimiter varchar2(30) := '==============================';
    c_debug_subdelimiter varchar2(30) := '------------------------------';

    http_req utl_http.req; --обьект запроса
    http_resp utl_http.resp; --обьект ответа

    body_length number;
    buffer_req varchar2(32767); --буфер под тело запроса
    buffer_resp varchar2(32767); --буфер под тело ответа
    eob boolean := false;

    temp_clob clob;
    response_clob clob; --итоговое тело ответа
begin
    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --установка таймаута соединения
    if (p_debug) then dbms_output.put_line('timeout: '||p_timeout); end if;
    utl_http.set_transfer_timeout(p_timeout);

    --режим сжатия, например "gzip"
    if (p_encoding is not null) then
        utl_http.set_content_encoding_support(p_encoding, true);
    end if;

    --при обращении к https потребуется подписывать ваши запросы
    if (p_debug) then dbms_output.put_line('with wallet: '||case when p_secure then 'true' else 'false' end); end if;
    if (p_secure) then
        utl_http.set_wallet('путь/до/физического/сертификата/на/вашем/сервере', 'пароль');
    end if;

    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --выполнение запроса
    --формируем обьект запроса
    if (p_debug) then dbms_output.put_line('begin request: '||p_method||' '||p_url); end if;
    http_req := utl_http.begin_request(
        url => p_url,
        method => p_method,
        http_version => utl_http.http_version_1_1
        --request_context => null,
        --https_host => p_https_host
    );

    if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;

    --запаковка заголовков нашего запроса
    if (p_debug) then dbms_output.put_line('request headers:'); end if;

    --если мы указали режим сжатия, то его еще нужно отдельно указать в заголовке
    if (p_debug) then dbms_output.put_line('with encoding: '||case when p_encoding is null then 'false' else p_encoding end); end if;
    if (p_encoding is not null) then
        utl_http.set_header(http_req, 'accept-encoding', p_encoding);
        if (p_debug) then dbms_output.put_line('"accept-encoding" : "'||p_encoding||'"'); end if;
    end if;

    --известным нам способом прохода по массиву
    --устанавливаем все наши пользовательские заголовки
    if (p_headers is not null) then
    if (p_headers.count > 0) then
    for i in p_headers.first..p_headers.last
    loop
    declare
        v_header lebedev_eg.t_fetch_header := p_headers(i);
    begin
        if (p_debug) then dbms_output.put_line('"'||v_header.name||'" : "'||v_header.value||'"'); end if;
        utl_http.set_header(http_req, v_header.name, v_header.value);
    end;
    end loop;
    end if;
    end if;

    --если метод не get, то мы обязаны передать тело
    --для этого указываем какого типа у нас тело и его хар-ки
    --также в заголовках
    if (p_method <> 'get') then
    declare
        v_content_type varchar2(100) := 'application/json; charset='||p_charset;
        --к сожалению функция подсчета длины тела нашего запроса с учетом кодировки
        --написана на java. внедрить ее в учебный проект не вышло
        v_content_length number := case when p_body is null then 0 else 0 /*здесь должен быть подсчет, а не 0*/ end;
    begin
        utl_http.set_header(http_req, 'content-type', v_content_type);
        if (p_debug) then dbms_output.put_line('"content-type" : "'||v_content_type||'"'); end if;

        utl_http.set_header(http_req, 'content-length', v_content_length);
        if (p_debug) then dbms_output.put_line('"content-length" : "'||v_content_length||'"'); end if;
    end;
    end if;

    if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;

    --запаковка тела запроса
    if (p_debug) then dbms_output.put_line('request body:'); end if;

    --опять же только если это не get
    if (p_method <> 'get') then
        --указываем кодировку нашего тела
        utl_http.set_body_charset(http_req, p_charset);

        --устанавливаем тело в запрос
        --поскольку мы имеем право передать данные
        --больше чем нам позволяет varchar2,
        --а инструменты для установки тела у нас varchar2 и raw,
        --нам приходится делить наш clob на куски равные максимуму varchar2
        --и в цикле заносить в наш запрос
        body_length := length(p_body);

        if body_length > 32767 then
            --считаем сколько будет кусков
            body_length := ceil(body_length / 32500);

            --начинаем цикл
            for i in 1..body_length
            loop
                --режем тело
                buffer_req := substr(
                    p_body,
                    32500 * i - 32499,
                    32500
                );

                --заносим в запрос
                utl_http.write_text(
                    http_req,
                    buffer_req
                );
                if (p_debug) then dbms_output.put_line(buffer_req); end if;
            end loop;
        else
            --если тело влезает в varchar2 можно обойтись без цикла
            utl_http.write_text(http_req, p_body);
            if (p_debug) then dbms_output.put_line(p_body); end if;
        end if;
    end if;

    --получаем обьект ответа
    http_resp := utl_http.get_response(http_req);

    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --успехом запроса в данной реализации считается только ответ с кодом 200
    if (p_debug) then dbms_output.put_line('response code: '||http_resp.status_code); end if;
    out_code := http_resp.status_code;
    out_success := http_resp.status_code in (200);

    if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;

    --распаковка тела ответа
    dbms_lob.createtemporary(temp_clob, false); --специальная функция для работы с формированием clob
    if (p_debug) then dbms_output.put_line('response body:'); end if;
    declare
        v_chunk_number number := 1;
    begin
        while not (eob)
        loop
        begin
            --потоковое чтение
            utl_http.read_text(http_resp, buffer_resp, 32767);

            if (p_debug) then dbms_output.put_line('-- '||v_chunk_number||' chunk '||c_debug_subdelimiter); end if;
            if (p_debug) then dbms_output.put_line(buffer_resp); end if;

            if (
                buffer_resp is not null
                and length(buffer_resp) > 0
            ) then
                dbms_lob.writeappend( --наполнение нашего результирущего clob
                    temp_clob,
                    length(buffer_resp),
                    buffer_resp
                );
            end if;

            v_chunk_number := v_chunk_number+1;
        exception
            --если при потоковом чтении будет достигунт конец
            --сбросится соответствующая ошибка
            --сигнализирующая нам о выходе из цикла
            when utl_http.end_of_body then
                eob := true;
        end;
        end loop;

        if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;

        --распаковываем заголовки ответа
        --нужно только для отладки
        if (p_debug) then dbms_output.put_line('response headers:'); end if;
        declare
            name  varchar2(256);
            value varchar2(1024);
        begin
            --начинаем цикл по кол-ву заголовков ответа
            for i in 1..utl_http.get_header_count(http_resp) loop
                --извлекаем и выводим в консоль
                utl_http.get_header(http_resp, i, name, value);
                if (p_debug) then dbms_output.put_line('"'||name||'" : "'||value||'"'); end if;
            end loop;
        end;

        --обязательно закрываем обьекты
        --освободит память и в запросе и в ответе
        utl_http.end_response(http_resp);
    exception
        when others then
            --освождаем память запроса
            utl_http.end_request(http_req);
    end;

    if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

    --в зависимости от реализации флага успеха запроса
    --и в зависимости от того с какими сервисами вы общаетесь
    --надо решить отдавать тело при провале или нет
    --я всегда отдаю, но при ошибке еще и логирую
    if (out_success) then
        response_clob := temp_clob;
    else
        response_clob := temp_clob;
        LEBEDEV_EG.ADD_ERROR_LOG(
            $$plsql_unit_owner||'.'||$$plsql_unit,
            '{"error":"' || http_resp.status_code
            || '","executor":"' || p_executor
            || '","url":"' || p_url
            || '","method":"' || p_method
            || '","body":"' || substr(p_body,1,1000)
            || '","response":"' || substr(temp_clob,1,2000)
            || '"}');
    end if;

    --освобождаем память и в запросе и в ответе
    utl_http.end_response(http_resp);
    --освобождаем память буфера clob
    dbms_lob.freetemporary(lob_loc => temp_clob);

    return response_clob;
exception
    when others then
        --отладка
        if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;
        if (p_debug) then dbms_output.put_line('error: '||sqlerrm); end if;
        if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;
        if (p_debug) then dbms_output.put_line('stack: '||dbms_utility.format_error_stack()); end if;
        if (p_debug) then dbms_output.put_line(c_debug_subdelimiter); end if;
        if (p_debug) then dbms_output.put_line('trace: '||dbms_utility.format_error_backtrace()); end if;
        if (p_debug) then dbms_output.put_line(c_debug_delimiter); end if;

        --логируем
        LEBEDEV_EG.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit,
            '{"error":"' || sqlerrm
            || '","executor":"' || p_executor
            || '","url":"' || p_url
            || '","method":"' || p_method
            || '","body":"' || substr(p_body,1,1000)
            || '","code":"' || http_resp.status_code
            || '","response":"' || substr(temp_clob,1,1000)
            || '","stack":"' || dbms_utility.format_error_stack()
            || '","backtrace":"' || dbms_utility.format_error_backtrace()
            || '"}');

        --освобождаем память и в запросе и в ответе
        --отдаем все нужные поля
        utl_http.end_response(http_resp);
        out_success := false;
        return null;
end;
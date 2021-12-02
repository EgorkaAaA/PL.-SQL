-- Задание 2: отлавливать ошибки

-- Создание пакета с ошибками и select'ом для логов
create or replace package lebedev_eg.exceptions
as
    patient_already_reg exception;

    patient_sex_not_equals_speciality_sex exception;

    speciality_not_exists exception;

    age_group_not_exists exception;

    patient_not_exists exception;

    sex_not_exists exception;

    phone_number_not_valid exception;

    document_not_exists exception;

    doctor_not_exists exception;

    hospital_not_exists exception;

    medical_organization_not_exists exception;

    hospital_tape_not_exists exception;

    hospital_time_table_not_exist exception;

    day_of_weak_not_exist exception;

    talon_doctor_not_exist exception;

    -- Создаю тип массива для того чтобы возвращать его в фунции
    type array_of_logs is varray(500) of lebedev_eg.logs%rowtype;

    -- select на вывод ошибок из логов
    function get_logs(
        p_start_date date,
        p_finish_date date,
        p_object varchar2,
        p_value varchar2
    )
    return lebedev_eg.exceptions.array_of_logs;
end;

--Тело пакета
create or replace package body lebedev_eg.exceptions
as
    array_of_rows lebedev_eg.exceptions.array_of_logs;

    -- select на вывод ошибок из логов
    function get_logs(
        p_start_date date,
        p_finish_date date,
        p_object varchar2,
        p_value varchar2
    )
    return lebedev_eg.exceptions.array_of_logs
    as
    begin
        select *
        bulk collect into array_of_rows
        from lebedev_eg.logs l
        where (p_start_date is null or p_start_date <= l.date_log)
            and
              (p_finish_date is null or p_finish_date >= l.date_log)
            and
              (p_object is null or l.sh_object = p_object)
            and
              (p_value is null  or l.value_json like '%' || p_value || '%');

        return array_of_rows;
    end;
end;


-- Тестовый анонимный блок
declare
    array lebedev_eg.exceptions.array_of_logs;
begin
    array := lebedev_eg.exceptions.get_logs(null,sysdate,null,null);
    for i in 1..array.count
    loop
        dbms_output.put_line(array(i).value_json);
        end loop;
end;
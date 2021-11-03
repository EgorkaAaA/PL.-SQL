--1
declare
    cursor cursor_1_for_select_regions_and_city(
        id_region_cursor number
        )
        is

        select c.city_name, name_region
        from city c
        inner join region r on r.id_region = c.id_region
        where (id_region_cursor is null and c.id_city is not null)
            or (r.id_region = id_region_cursor);

    cursor_2_for_select_regions_and_city sys_refcursor;

    id_region_cursor number;
    type record_for_cursor is record (
        name_region varchar2(100),
        name_city varchar2(100)
                                     );
    record_1 record_for_cursor;
begin
    -- статичный курсов
    dbms_output.put_line('статичный курсор');
    for i in cursor_1_for_select_regions_and_city(null)
    loop
        dbms_output.put_line('название региона:  ' || i.name_region || '  название города:  '||i.city_name);
        end loop;


    -- курсор переменная
    dbms_output.put_line('курсор переменная');
    id_region_cursor := 1;
    open cursor_2_for_select_regions_and_city for
        select c.city_name, name_region
        from city c
        inner join region r on r.id_region = c.id_region
        where (id_region_cursor is null and c.id_city is not null)
            or (r.id_region = id_region_cursor);

    loop
        fetch cursor_2_for_select_regions_and_city into record_1;
        exit when cursor_2_for_select_regions_and_city%notfound;
        dbms_output.put_line('название региона:  ' || record_1.name_region || '  название города:  '||record_1.name_city);
    end loop;

    -- неявный курсор
    id_region_cursor := 3;
    dbms_output.put_line('неявный курсор');
    for i in (select c.city_name, name_region
        from city c
        inner join region r on r.id_region = c.id_region
        where (id_region_cursor is null and c.id_city is not null)
            or (r.id_region = id_region_cursor))
    loop
        dbms_output.put_line('название региона:  ' || i.name_region || '  название города:  '||i.city_name);
        end loop;
end;
--2
declare
    cursor v_cursor_select_speciality (
            id_speciality_cursor number
        )
        is
    select distinct s.* from lebedev_eg.speciality s
        inner join lebedev_eg.doctor_speciality ds
        on s.id_speciality = ds.id_speciality
        inner join doctor d
        on ds.id_doctor = d.id_doctor
        inner join lebedev_eg.hospital h
        on h.id_hospital = d.id_hospital
        where ((id_speciality_cursor is null)
            or (id_speciality_cursor = s.id_speciality))
               and (s.deleted is null and d.deleted is null and h.deleted is null);

    record_1 lebedev_eg.speciality%rowtype;

    cursor_select_speciality_2 sys_refcursor;
    id_speciality_cursor number;
begin
    --статический курсор
    dbms_output.put_line('статический курсор');
    open v_cursor_select_speciality(null);

    loop
        fetch v_cursor_select_speciality into record_1;
        exit when v_cursor_select_speciality%notfound;
            dbms_output.put_line(record_1.name_speciality || '  ' || record_1.id_age_group);
    end loop;
    close v_cursor_select_speciality;

    --курсор переменная
    dbms_output.put_line('курсор переменная');
    open cursor_select_speciality_2 for
        select distinct s.* from lebedev_eg.speciality s
        inner join lebedev_eg.doctor_speciality ds
        on s.id_speciality = ds.id_speciality
        inner join doctor d
        on ds.id_doctor = d.id_doctor
        inner join lebedev_eg.hospital h
        on h.id_hospital = d.id_hospital
        where ((id_speciality_cursor is null)
            or (id_speciality_cursor = s.id_speciality))
               and (s.deleted is null and d.deleted is null and h.deleted is null);

    loop
        fetch cursor_select_speciality_2 into record_1;
        exit when cursor_select_speciality_2%notfound;
            dbms_output.put_line(record_1.name_speciality || '  ' || record_1.id_age_group);
        end loop;
    close cursor_select_speciality_2;

    --неявный курсор
    dbms_output.put_line('неявный курсор');

    for i in (
        select distinct s.* from lebedev_eg.speciality s
        inner join lebedev_eg.doctor_speciality ds
        on s.id_speciality = ds.id_speciality
        inner join doctor d
        on ds.id_doctor = d.id_doctor
        inner join lebedev_eg.hospital h
        on h.id_hospital = d.id_hospital
        where ((id_speciality_cursor is null)
            or (id_speciality_cursor = s.id_speciality))
               and (s.deleted is null and d.deleted is null and h.deleted is null)
        )
    loop
        dbms_output.put_line(i.name_speciality || '  ' || i.id_age_group);
    end loop;
end;

--3
declare
    cursor cursor_for_select_1(
        v_id_speciality number
        )
        is

        select count(d.id_doctor) as count, h.name_hospital, ds.id_speciality,h.is_open  from hospital h
        inner join lebedev_eg.doctor d
        on h.id_hospital = d.id_hospital
        inner join lebedev_eg.doctor_speciality ds
        on ds.id_doctor = d.id_doctor
        where (v_id_speciality is null or ds.id_speciality = v_id_speciality) and (h.deleted is null and d.deleted is null)
        group by (h.id_hospital, h.name_hospital,h.is_open,h.id_hospital_tape, ds.id_speciality)
        order by case when h.id_hospital_tape = (select ht.id_hospital_tape from hospital_tape ht where ht.name_hospital_tape = 'государственная')
                    then 0
                    else 1
                end desc,
                 count(d.id_doctor) desc,
                h.is_open desc;

    type record_for_cursor is record (
        count number,
        name_hospital varchar2(100),
        id_speciality number,
        is_open number
                                     );

    v_record_1 record_for_cursor;

    cursor_for_select sys_refcursor;
    v_id_speciality number := 5;
begin
    --статический курсор
    dbms_output.put_line('статический курсор');
    for i in cursor_for_select_1(null)
        loop
            dbms_output.put_line(i.count || '  ' || i.name_hospital || '  ' || i.id_speciality || '   ' || i.is_open);
        end loop;

    --курсор переменная
    dbms_output.put_line('курсор переменная');
    open cursor_for_select for
        select count(d.id_doctor) as count, h.name_hospital, ds.id_speciality,h.is_open  from hospital h
        inner join lebedev_eg.doctor d
        on h.id_hospital = d.id_hospital
        inner join lebedev_eg.doctor_speciality ds
        on ds.id_doctor = d.id_doctor
        where ((v_id_speciality is null) or (ds.id_speciality = v_id_speciality)) and (h.deleted is null and d.deleted is null)
        group by h.id_hospital, h.name_hospital,h.is_open,h.id_hospital_tape, ds.id_speciality
        order by case when h.id_hospital_tape = (select ht.id_hospital_tape from hospital_tape ht where ht.name_hospital_tape = 'государственная')
                    then 0
                    else 1
                end desc,
                 count(d.id_doctor) desc,
                h.is_open desc;
    loop
        fetch cursor_for_select into v_record_1;
        exit when cursor_for_select%notfound;
        dbms_output.put_line(v_record_1.count || '  ' || v_record_1.name_hospital || '  ' || v_record_1.id_speciality || '  ' || v_record_1.is_open);
    end loop;
    close cursor_for_select;


    --неявный курсор
    dbms_output.put_line('неявный курсор');
    for i in (
        select count(d.id_doctor) as count, h.name_hospital, ds.id_speciality,h.is_open  from hospital h
        inner join lebedev_eg.doctor d
        on h.id_hospital = d.id_hospital
        inner join lebedev_eg.doctor_speciality ds
        on ds.id_doctor = d.id_doctor
        where ((v_id_speciality is null) or (ds.id_speciality = v_id_speciality)) and (h.deleted is null and d.deleted is null)
        group by h.id_hospital, h.name_hospital,h.is_open,h.id_hospital_tape, ds.id_speciality
        order by case when h.id_hospital_tape = (select ht.id_hospital_tape from hospital_tape ht where ht.name_hospital_tape = 'государственная')
                    then 0
                    else 1
                end desc,
                 count(d.id_doctor) desc,
                h.is_open desc)
    loop
        dbms_output.put_line(i.count || '  ' || i.name_hospital || '  ' || i.id_speciality || '   ' || i.is_open);
        end loop;
end;


--4
declare
    cursor v_cursor_for_select_1 (
        v_id_hospital number,
        v_area number
        )
    is
        select * from doctor d
        where (d.id_hospital = v_id_hospital or v_id_hospital is null) and d.deleted is null
        order by d.qualification,
                case when d.area = v_area then 1
                     else 0
                end;

    v_record lebedev_eg.doctor%rowtype;

    v_cursor_for_select_2 sys_refcursor;
    v_id_hospital number;
    v_area number;

begin
    --статический курсор
    dbms_output.put_line('статический курсор');
    for i in v_cursor_for_select_1(76,null)
    loop
        dbms_output.put_line(i.id_doctor || '  ' || i.id_hospital || '  ' || i.area );
        end loop;

    --курсор переменная
    dbms_output.put_line('курсор переменная');
    open v_cursor_for_select_2 for
        select * from doctor d
        where (d.id_hospital = v_id_hospital or v_id_hospital is null) and d.deleted is null
        order by d.qualification,
                case when d.area = v_area then 1
                     else 0
                end;
    loop
        fetch v_cursor_for_select_2 into v_record;
        exit when v_cursor_for_select_2%notfound;
            dbms_output.put_line(v_record.id_doctor || '  ' || v_record.id_hospital || '  ' || v_record.area);
    end loop;
    close v_cursor_for_select_2;

    --неявный курсор
    dbms_output.put_line('неявный курсор');
    for i in (select * from doctor d
        where (d.id_hospital = v_id_hospital or v_id_hospital is null) and d.deleted is null
        order by d.qualification,
                case when d.area = v_area then 1
                     else 0
                end
        )
    loop
        dbms_output.put_line(i.id_doctor || '  ' || i.id_hospital || '  ' || i.area );
        end loop;
end;

--5
declare
    cursor v_cursor_for_select_1 (
        v_id_doctor number
        )
    is
    select * from lebedev_eg.doctor_timetable dt
        where
              (v_id_doctor is null or dt.id_doctor = v_id_doctor)
          and
              (dt.time_spaces_to < sysdate and dt.time_spaces_from < sysdate);

    v_id_doctor number;

    v_cursor_for_select_2 sys_refcursor;

    record_1 lebedev_eg.doctor_timetable%rowtype;
begin
    v_id_doctor := 1;

    --статический курсор
    dbms_output.put_line('статический курсор');
    for i in v_cursor_for_select_1
    loop
        dbms_output.put_line(i.id_doctor);
        end loop;

    --курсор переменная
    dbms_output.put_line('курсор переменная');
    open v_cursor_for_select_2 for
        select * from lebedev_eg.doctor_timetable dt
         where
              (v_id_doctor is null or dt.id_doctor = v_id_doctor)
          and
              (dt.time_spaces_to < sysdate and dt.time_spaces_from < sysdate);
    loop
        fetch v_cursor_for_select_2 into record_1;
        exit when v_cursor_for_select_2%notfound;
            dbms_output.put_line(record_1.id_doctor);
    end loop;
    close v_cursor_for_select_2;
    --неявный курсор
    dbms_output.put_line('неявный курсор');
    for i in ( select * from lebedev_eg.doctor_timetable dt
    where
              (v_id_doctor is null or dt.id_doctor = v_id_doctor)
          and
              (dt.time_spaces_to < sysdate and dt.time_spaces_from < sysdate))
    loop
        dbms_output.put_line(i.id_doctor);
        end loop;
end;


--6
declare
    cursor cursor_for_select_documents_1 (
        v_id_document number
        )
    is
    select * from lebedev_eg.document d
    where d.id_document = v_id_document or v_id_document is null;

    cursor_for_select_documents_2 sys_refcursor;

    record_1 lebedev_eg.document%rowtype;

    v_id_document number;
begin
    --статический курсор
    dbms_output.put_line('статический курсор');
    for i in cursor_for_select_documents_1(null)
    loop
        dbms_output.put_line(i.name);
        end loop;

    v_id_document := 8;
    --курсор переменная
    dbms_output.put_line('курсор переменная');
    open cursor_for_select_documents_2 for
        select * from lebedev_eg.document d
        where d.id_document = v_id_document or v_id_document is null;
    loop
        fetch cursor_for_select_documents_2 into record_1;
        exit when cursor_for_select_documents_2%notfound;
        dbms_output.put_line(record_1.name);
    end loop;
    close cursor_for_select_documents_2;
    v_id_document := 7;
    --неявный курсор
    dbms_output.put_line('неявный курсор');
    for i in (
        select * from lebedev_eg.document d
        where d.id_document = v_id_document or v_id_document is null
        )
    loop
        dbms_output.put_line(i.name);
        end loop;
end;


--7
declare
    cursor cursor_for_select_timetable_1 (
        v_id_hospital number
        )
    is
    select * from lebedev_eg.hospital_timetable ht
        where v_id_hospital is null or  ht.id_hospital = v_id_hospital;

    cursor_for_select_timetable_2 sys_refcursor;

    record_1 lebedev_eg.hospital_timetable%rowtype;
    v_id_hospital number;
begin
    for i in cursor_for_select_timetable_1(null)
    loop
        dbms_output.put_line(i.id_hospital || '  '|| i.id_day || '  '|| to_char(i.start_work_time, 'hh24:mi') || '  ' || to_char(i.finish_work_time, 'hh24:mi'));
        end loop;
    open cursor_for_select_timetable_2
        for
            select * from lebedev_eg.hospital_timetable ht
            where v_id_hospital is null or  ht.id_hospital = v_id_hospital;

    loop
        fetch cursor_for_select_timetable_2 into record_1;
        exit when cursor_for_select_timetable_2%notfound;
            dbms_output.put_line(record_1.id_hospital || '  '|| record_1.id_day || '  '|| to_char(record_1.start_work_time, 'hh24:mi') || '  ' || to_char(record_1.finish_work_time, 'hh24:mi'))
    end loop;

    close cursor_for_select_timetable_2;

    for i in (select * from lebedev_eg.hospital_timetable ht
        where v_id_hospital is null or  ht.id_hospital = v_id_hospital)
    loop
        dbms_output.put_line(i.id_hospital || '  '|| i.id_day || '  '|| to_char(i.start_work_time, 'hh24:mi') || '  ' || to_char(i.finish_work_time, 'hh24:mi'));
        end loop;
end;


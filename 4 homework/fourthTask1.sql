-- 1 задание:
-- переношу курсоры в фунции, потому что так удобнее возвращать курсоры
create or replace function lebedev_eg.select_city_on_region_as_func (
    v_id_region number
)
return sys_refcursor
as
    v_cursor_select_city sys_refcursor;

    begin
        open v_cursor_select_city for
        select c.city_name, name_region
        from city c
        inner join region r on r.id_region = c.id_region
        where (v_id_region is null and c.id_city is not null)
            or (r.id_region = v_id_region);
        return v_cursor_select_city;
    end;


declare
    v_cursor sys_refcursor;
        type record_for_cursor is record (
        name_region varchar2(100),
        name_city varchar2(100)
                                     );
    record_1 record_for_cursor;
begin
    v_cursor := lebedev_eg.select_city_on_region_as_func(null);

    loop
        fetch v_cursor into record_1;
        exit when v_cursor%notfound;

        dbms_output.put_line(record_1.name_city|| '   ' || record_1.name_region);
    end loop;
    close v_cursor;
end;


create or replace function lebedev_eg.select_active_speciality(
    v_id_speciality number
)
return sys_refcursor
as
    v_cursor_1 sys_refcursor;
begin
    open v_cursor_1 for
        select distinct s.* from lebedev_eg.speciality s
        inner join lebedev_eg.doctor_speciality ds
        on s.id_speciality = ds.id_speciality
        inner join doctor d
        on ds.id_doctor = d.id_doctor
        inner join lebedev_eg.hospital h
        on h.id_hospital = d.id_hospital
        where ((v_id_speciality is null)
            or (v_id_speciality = s.id_speciality))
               and (s.deleted is null and d.deleted is null and h.deleted is null);
    return v_cursor_1;
end;


declare
    v_cursor_1 sys_refcursor;
    record lebedev_eg.speciality%rowtype;
begin
    v_cursor_1 := lebedev_eg.select_active_speciality(null);

    loop
        fetch v_cursor_1 into record;
        exit when v_cursor_1%notfound;
        dbms_output.put_line(record.name_speciality);
    end loop;
end;

create or replace function lebedev_eg.select_hospital_on_speciality(
    v_id_speciality number
)
return sys_refcursor
as
    v_cursor_1 sys_refcursor;
begin
    open v_cursor_1 for
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
    return v_cursor_1;
end;

declare
    v_cursor sys_refcursor;
    type record_for_cursor is record (
        count number,
        name_hospital varchar2(100),
        id_speciality number,
        is_open number
                                     );

    v_record_1 record_for_cursor;
begin
    v_cursor := lebedev_eg.select_hospital_on_speciality(4);

    loop
        fetch v_cursor into v_record_1;
        exit when v_cursor%notfound;
        dbms_output.put_line(v_record_1.count || '  ' || v_record_1.name_hospital || '  ' || v_record_1.id_speciality || '  ' || v_record_1.is_open);
    end loop;

    close v_cursor;
end;

create or replace function lebedev_eg.select_doctors_on_hospital_as_func(
    v_id_hospital number,
    v_area number
)
return sys_refcursor
as
    v_cursor sys_refcursor;
begin
    open v_cursor for
        select * from doctor d
        where (d.id_hospital = v_id_hospital or v_id_hospital is null) and d.deleted is null
        order by d.qualification,
                case when d.area = v_area then 1
                     else 0
                end;

    return v_cursor;
end;


declare
    v_cursor sys_refcursor;

    v_record lebedev_eg.doctor%rowtype;

begin
    v_cursor := lebedev_eg.select_doctors_on_hospital_as_func(78,51);

    loop
        fetch v_cursor into v_record;
        exit when v_cursor%notfound;
        dbms_output.put_line(v_record.id_doctor || '  ' || v_record.id_hospital || '  ' || v_record.area);
    end loop;
end;

create or replace function lebedev_eg.select_talon_on_doctor_active_date_as_func(
    v_id_doctor number
)
return sys_refcursor
as
    v_cursor sys_refcursor;
begin
    open v_cursor for
        select * from lebedev_eg.doctor_timetable dt
         where
              (v_id_doctor is null or dt.id_doctor = v_id_doctor)
          and
              (dt.time_spaces_to < sysdate and dt.time_spaces_from < sysdate);

    return v_cursor;
end;

declare
    v_cursor sys_refcursor;

    v_record lebedev_eg.doctor_timetable%rowtype;
begin
    v_cursor := lebedev_eg.select_talon_on_doctor_active_date_as_func(8);

    loop
        fetch v_cursor into v_record;
        exit when v_cursor%notfound;
            dbms_output.put_line(v_record.time_spaces_from || '    ' || v_record.time_spaces_to );
    end loop;
    close v_cursor;
end;

create or replace function lebedev_eg.select_document_as_func(
    v_id_document number
)
return sys_refcursor
as
    v_cursor sys_refcursor;
begin
    open v_cursor for
      select * from lebedev_eg.document d
        where d.id_document = v_id_document or v_id_document is null;
    return v_cursor;
end;

declare
    v_cursor sys_refcursor;
    v_record lebedev_eg.document%rowtype;
begin
    v_cursor := lebedev_eg.select_document_as_func(8);
    loop
        fetch v_cursor into v_record;
        exit when v_cursor%notfound;
        dbms_output.put_line(v_record.name);
    end loop;
    close v_cursor;
end;

create or replace function lebedev_eg.select_hospital_timetable_as_func(
    v_id_hospital number
)
return sys_refcursor
as
    v_cursor sys_refcursor;
begin
    open v_cursor for
         select * from lebedev_eg.hospital_timetable ht
            where v_id_hospital is null or  ht.id_hospital = v_id_hospital;

    return v_cursor;
end;

declare
    v_cursor sys_refcursor;
    v_record lebedev_eg.hospital_timetable%rowtype;
begin
    v_cursor := lebedev_eg.select_hospital_timetable_as_func(56);
        loop
        fetch v_cursor into v_record;
        exit when v_cursor%notfound;
            dbms_output.put_line(v_record.id_hospital || '  '|| v_record.id_day || '  '|| to_char(v_record.start_work_time, 'hh24:mi') || '  ' || to_char(v_record.finish_work_time, 'hh24:mi'));
    end loop;

    close v_cursor;

end;


-- 3 задание:

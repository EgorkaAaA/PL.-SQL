-- 1 Задание:
-- Переношу курсоры в фунции, потому что так удобнее возвращать курсоры
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
        order by case when h.id_hospital_tape = (select ht.id_hospital_tape from hospital_tape ht where ht.name_hospital_tape = 'Государственная')
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

    v_record lebedev_eg.DOCTOR%rowtype;

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

    v_record lebedev_eg.DOCTOR_TIMETABLE%rowtype;
begin
    v_cursor := lebedev_eg.select_talon_on_doctor_active_date_as_func(8);

    loop
        fetch v_cursor into v_record;
        exit when v_cursor%notfound;
            dbms_output.put_line(v_record.TIME_SPACES_FROM || '    ' || v_record.TIME_SPACES_TO );
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
    v_record lebedev_eg.DOCUMENT%rowtype;
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
    v_record lebedev_eg.HOSPITAL_TIMETABLE%rowtype;
begin
    v_cursor := lebedev_eg.select_hospital_timetable_as_func(56);
        loop
        fetch v_cursor into v_record;
        exit when v_cursor%notfound;
            dbms_output.put_line(v_record.id_hospital || '  '|| v_record.id_day || '  '|| to_char(v_record.start_work_time, 'hh24:mi') || '  ' || to_char(v_record.finish_work_time, 'hh24:mi'));
    end loop;

    close v_cursor;

end;


-- 2 Задание:
-- Добавил немного ооп
create or replace function lebedev_eg.select_patient_age(
    v_id_patient number
)
return number
as
    v_cursor_for_select_birthday sys_refcursor;
    v_birthday date;
begin
    open v_cursor_for_select_birthday for
        select p.birthday from PATIENT p
        where p.ID_PATIENT = v_id_patient;
    fetch v_cursor_for_select_birthday into v_birthday;
    close v_cursor_for_select_birthday;
    return floor((sysdate - v_birthday) / 365);
end;


-- Сама процедура 2-го задания
create or replace procedure lebedev_eg.patient_registration_on_talon_as_proc(
    v_id_patient in number,
    v_id_talon in number
)
as
    v_cursor_for_select_patient_sex sys_refcursor;
    v_cursor_for_select_doctor_id sys_refcursor;
    v_cursor_for_select_talon_in_journal sys_refcursor;
    v_id_doctor number;
    v_is_open number;
    v_id_sex number;
    v_age number;
    v_flag boolean;
    v_record_for_journal lebedev_eg.JOURNAL%rowtype;
begin
    v_age := lebedev_eg.select_patient_age(v_id_patient);
    open v_cursor_for_select_patient_sex for
        select p.ID_SEX from lebedev_eg.PATIENT p
        inner join PATIENT_DOCUMENT pd
        on pd.ID_PATIENT = p.ID_PATIENT
        inner join DOCUMENT d
        on pd.ID_DOCUMENT = d.ID_DOCUMENT
        where p.ID_PATIENT = v_id_patient and d.NAME = 'ОМС';
    fetch v_cursor_for_select_patient_sex into v_id_sex;
    close v_cursor_for_select_patient_sex;

    open v_cursor_for_select_doctor_id for
        select dt.ID_DOCTOR, dt.IS_OPEN from lebedev_eg.DOCTOR_TIMETABLE dt
        inner join DOCTOR D
            on dt.ID_DOCTOR = D.ID_DOCTOR
        where ID_TIMETABLE = v_id_talon and dt.TIME_SPACES_FROM > sysdate and d.DELETED is null;

    fetch v_cursor_for_select_doctor_id into v_id_doctor,v_is_open;
    close v_cursor_for_select_doctor_id;
    if v_is_open = 1 then
        v_flag:= true;
        elsif v_is_open is null then
        v_flag:= false;
        DBMS_OUTPUT.PUT_LINE('Либо нет такого талона, либо что-то со временем записи, либо доктор удален. Такие дела)');
    end if;
    if v_flag = true then
        v_flag := false;
        for i in (select s.ID_SPECIALITY,ag.MIN_AGE, ag.MAX_AGE, ds.ID_DOCTOR, ss.ID_SEX from DOCTOR_SPECIALITY ds
            inner join SPECIALITY s
            on ds.ID_SPECIALITY = s.ID_SPECIALITY
            inner join AGE_GROUP ag
            on s.ID_AGE_GROUP = ag.ID_AGE_GROUP
            inner join SPECIALITY_SEX ss
            on s.ID_SPECIALITY = ss.ID_SPECIALITY
            inner join DOCTOR d
            on ds.ID_DOCTOR = d.ID_DOCTOR
            inner join HOSPITAL h
            on d.ID_HOSPITAL = h.ID_HOSPITAL
            where ds.ID_DOCTOR = 494 and s.DELETED is null and h.DELETED is null)
        loop
            if i.MIN_AGE > v_age or v_age > i.MAX_AGE then
                DBMS_OUTPUT.PUT_LINE('Не подходит под возрастную группу');
                v_flag := false;
                elsif i.ID_SEX <> v_id_sex then
                    DBMS_OUTPUT.PUT_LINE('Не подходит пол');
                    v_flag := false;
                    else v_flag := true;
            end if;
            exit when v_flag = true;
            end loop;
    end if;

    open v_cursor_for_select_talon_in_journal for
        select * from JOURNAL where ID_TALON = v_id_talon and ID_PATIENT = v_id_patient;
    fetch v_cursor_for_select_talon_in_journal into v_record_for_journal;
    close v_cursor_for_select_talon_in_journal;

    DBMS_OUTPUT.PUT_LINE(v_record_for_journal.ID_PATIENT || '  ' || v_record_for_journal.ID_TALON);
    if v_record_for_journal.ID_PATIENT is not null then
        v_flag := false;
        DBMS_OUTPUT.PUT_LINE('Кажется кто-то уже записался на прием и этот кто-то: ' || v_id_patient);
    end if;

    if v_flag = true then
        insert into JOURNAL (ID_PATIENT, ID_TALON, AVAILABLE)
        VALUES (v_id_patient, v_id_talon, 1);
        update lebedev_eg.DOCTOR_TIMETABLE set IS_OPEN = 0 where ID_TIMETABLE = v_id_talon;
        DBMS_OUTPUT.PUT_LINE('Пользовтель успешно записался к врачу');
        commit;
        else
            DBMS_OUTPUT.PUT_LINE('Не записался');
    end if;
end;

begin
    lebedev_eg.patient_registration_on_talon_as_proc(7852, 4833);
end;

-- 3 Задание:
create or replace procedure lebedev_eg.cancel_registration_on_talon_as_proc (
    v_id_patient in number,
    v_id_talon in number
)
as
    v_cursor_for_select_talon sys_refcursor;
    v_id_talon_from_cursor number;
begin
    open v_cursor_for_select_talon for
        select DT.ID_TIMETABLE from DOCTOR_TIMETABLE DT
        inner join LEBEDEV_EG.DOCTOR D
            on D.ID_DOCTOR = DT.ID_DOCTOR
        inner join HOSPITAL H
            on H.ID_HOSPITAL = D.ID_HOSPITAL
        inner join HOSPITAL_TIMETABLE HT
            on H.ID_HOSPITAL = HT.ID_HOSPITAL
        where DT.ID_TIMETABLE = v_id_talon
          and DT.TIME_SPACES_FROM < sysdate
          and DT.IS_OPEN = 0
          and to_date(to_char(sysdate - interval '2' hour, 'hh24:mi'), 'hh24:mi') < to_date(to_char(FINISH_WORK_TIME,'hh24:mi'),'hh24:mi');

    fetch v_cursor_for_select_talon into v_id_talon_from_cursor;

    close v_cursor_for_select_talon;
    if v_id_talon_from_cursor is not null then
            update JOURNAL set AVAILABLE = 0 where ID_PATIENT = v_id_patient and ID_TALON = v_id_talon_from_cursor;
            update DOCTOR_TIMETABLE set IS_OPEN = 1 where ID_TIMETABLE = v_id_talon_from_cursor;
            DBMS_OUTPUT.PUT_LINE('Запись успешно отменена');
        else
            DBMS_OUTPUT.PUT_LINE('Не то');
    end if;
end;
--1
begin
    for i in (select C.CITY_NAME, NAME_REGION
    from CITY C
    inner join REGION R on R.ID_REGION = C.ID_REGION)
    loop
        DBMS_OUTPUT.PUT_LINE('Название региона:  ' || i.NAME_REGION || '  Название города:  '||i.CITY_NAME);
        end loop;
end;
--2
declare
    cursor v_cursor_select_speciality is
    select distinct S.* from LEBEDEV_EG.SPECIALITY S
        inner join LEBEDEV_EG.DOCTOR_SPECIALITY DS
        on S.ID_SPECIALITY = DS.ID_SPECIALITY
        inner join DOCTOR D
        on DS.ID_DOCTOR = D.ID_DOCTOR
        inner join LEBEDEV_EG.HOSPITAL H
        on H.ID_HOSPITAL = D.ID_HOSPITAL
        WHERE S.DELETED is null and D.DELETED is null and H.DELETED is null;

    record_1 LEBEDEV_EG.SPECIALITY%rowtype;

begin
    open v_cursor_select_speciality;


    loop
        fetch v_cursor_select_speciality into record_1;
        exit when v_cursor_select_speciality%notfound;
            DBMS_OUTPUT.PUT_LINE(record_1.NAME_SPECIALITY || '  ' || record_1.id_age_group);
    end loop;
    close v_cursor_select_speciality;
end;

--3
declare
    cursor_for_select sys_refcursor;
    v_id_speciality number := 5;
begin
    if v_id_speciality is null
       then
        open cursor_for_select for
            SELECT count(D.ID_DOCTOR) as count, H.NAME_HOSPITAL, DS.ID_SPECIALITY,H.IS_OPEN  from HOSPITAL H
            inner join LEBEDEV_EG.DOCTOR D
            on H.ID_HOSPITAL = D.ID_HOSPITAL
            inner join LEBEDEV_EG.DOCTOR_SPECIALITY DS
            on DS.ID_DOCTOR = D.ID_DOCTOR
            where  H.DELETED is null and D.DELETED is null
            group by H.ID_HOSPITAL, H.NAME_HOSPITAL,H.IS_OPEN,H.ID_HOSPITAL_TAPE, DS.ID_SPECIALITY
            order by case when H.ID_HOSPITAL_TAPE = (select HT.ID_HOSPITAL_TAPE from HOSPITAL_TAPE HT where HT.NAME_HOSPITAL_TAPE = 'Государственная')
                        then 0
                        else 1
                    end desc,
                     count(D.ID_DOCTOR) desc,
                    H.IS_OPEN desc;
        else
            open cursor_for_select for
            SELECT count(D.ID_DOCTOR) as count, H.NAME_HOSPITAL, DS.ID_SPECIALITY,H.IS_OPEN  from HOSPITAL H
            inner join LEBEDEV_EG.DOCTOR D
            on H.ID_HOSPITAL = D.ID_HOSPITAL
            inner join LEBEDEV_EG.DOCTOR_SPECIALITY DS
            on DS.ID_DOCTOR = D.ID_DOCTOR
            where DS.ID_SPECIALITY = v_id_speciality and H.DELETED is null and D.DELETED is null
            group by H.ID_HOSPITAL, H.NAME_HOSPITAL,H.IS_OPEN,H.ID_HOSPITAL_TAPE, DS.ID_SPECIALITY
            order by case when H.ID_HOSPITAL_TAPE = (select HT.ID_HOSPITAL_TAPE from HOSPITAL_TAPE HT where HT.NAME_HOSPITAL_TAPE = 'Государственная')
                        then 0
                        else 1
                    end desc,
                     count(D.ID_DOCTOR) desc,
                    H.IS_OPEN desc;
            end if;
    loop
    declare
        v_count number;
        v_hospital_row varchar2(100);
        v_id_spec number;
        v_is_open number;
        begin
        fetch cursor_for_select into v_count,v_hospital_row,v_id_spec,v_is_open;
        exit when cursor_for_select%notfound;
        DBMS_OUTPUT.PUT_LINE(v_count || '  ' || v_hospital_row || '  ' || v_id_spec || '  ' || v_is_open);
    end;
    end loop;
    close cursor_for_select;
end;
--4
declare
    v_id_hospital number;
    v_area number;
begin
    v_id_hospital := null;
    v_area := null;
    if(v_id_hospital is null and v_area is null) then
        for i in (select * from DOCTOR D
                    where D.DELETED is null
                    order by d.QUALIFICATION)
        loop
            DBMS_OUTPUT.PUT_LINE(i.ID_DOCTOR);
            end loop;
        elsif v_id_hospital is null and v_area is not null then
            for i in (select * from DOCTOR D
                        where D.DELETED is null
                        order by d.QUALIFICATION,
                                 case when D.AREA = v_area then 1
                                    else 0
                    end)
        loop
            DBMS_OUTPUT.PUT_LINE(i.ID_DOCTOR);
            end loop;
        elsif v_id_hospital is not null and v_area is null then
            for i in (select * from DOCTOR D
                    where D.DELETED is null and D.ID_HOSPITAL = v_id_hospital
                    order by d.QUALIFICATION)
            loop
                DBMS_OUTPUT.PUT_LINE(i.ID_DOCTOR);
                end loop;
        else
            for i in (select * from DOCTOR D
                    where D.DELETED is null and D.ID_HOSPITAL = v_id_hospital
                    order by d.QUALIFICATION,
                             case when D.AREA = v_area then 1
                                else 0
                    end)
        loop
                DBMS_OUTPUT.PUT_LINE(i.ID_DOCTOR);
                end loop;
    end if;
end;

--5
declare
    v_id_doctor number;
begin
    v_id_doctor := 1;
    if v_id_doctor is null then
        for i in (select * from LEBEDEV_EG.DOCTOR_TIMETABLE dt
    where dt.TIME_SPACES_TO < sysdate and dt.TIME_SPACES_FROM < sysdate)
        loop
            DBMS_OUTPUT.PUT_LINE(i.ID_DOCTOR);
            end loop;
        else for i in (select * from LEBEDEV_EG.DOCTOR_TIMETABLE dt
    where dt.ID_DOCTOR = v_id_doctor and dt.TIME_SPACES_TO < sysdate and dt.TIME_SPACES_FROM < sysdate)
        loop
            DBMS_OUTPUT.PUT_LINE(i.ID_DOCTOR);
            end loop;
    end if;
end;


--Проблема 
declare
    cursor1 sys_refcursor;
    type v_record_1 is record(
        v_doc_count number,
        v_name_hosp varchar2(100),
        v_id_spec number,
        v_is_open number
                             );
begin
    open cursor1 for
        SELECT count(D.ID_DOCTOR) as count, H.NAME_HOSPITAL, DS.ID_SPECIALITY,H.IS_OPEN  from HOSPITAL H
            inner join LEBEDEV_EG.DOCTOR D
            on H.ID_HOSPITAL = D.ID_HOSPITAL
            inner join LEBEDEV_EG.DOCTOR_SPECIALITY DS
            on DS.ID_DOCTOR = D.ID_DOCTOR
            where DS.ID_SPECIALITY = 10 and H.DELETED is null and D.DELETED is null
            group by H.ID_HOSPITAL, H.NAME_HOSPITAL,H.IS_OPEN,H.ID_HOSPITAL_TAPE, DS.ID_SPECIALITY
            order by case when H.ID_HOSPITAL_TAPE = (select HT.ID_HOSPITAL_TAPE from HOSPITAL_TAPE HT where HT.NAME_HOSPITAL_TAPE = 'Государственная')
                        then 0
                        else 1
                    end desc,
                     count(D.ID_DOCTOR) desc,
                    H.IS_OPEN desc;
    fetch cursor1 into v_record_1;
    DBMS_OUTPUT.PUT_LINE(v_record_1.v_name_hosp);
    close cursor1;
end;


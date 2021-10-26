--1
select C.CITY_NAME, NAME_REGION
from CITY C
inner join REGION R on R.ID_REGION = C.ID_REGION;
--2
select S.NAME_SPECIALITY,S.ID_AGE_GROUP from LEBEDEV_EG.SPECIALITY S
inner join LEBEDEV_EG.DOCTOR_SPECIALITY DS
on S.ID_SPECIALITY = DS.ID_SPECIALITY
inner join DOCTOR D
on DS.ID_DOCTOR = D.ID_DOCTOR
inner join LEBEDEV_EG.HOSPITAL H
on H.ID_HOSPITAL = D.ID_HOSPITAL
WHERE S.DELETED is null and D.DELETED is null and H.DELETED is null;
--3 *Исправил
SELECT count(D.ID_DOCTOR) as count, H.*  from HOSPITAL H
inner join LEBEDEV_EG.DOCTOR D
on H.ID_HOSPITAL = D.ID_HOSPITAL
inner join LEBEDEV_EG.DOCTOR_SPECIALITY DS
on DS.ID_DOCTOR = D.ID_DOCTOR
where DS.ID_SPECIALITY = 2 and H.DELETED is null and D.DELETED is null
group by H.ID_HOSPITAL, H.NAME_HOSPITAL,H.IS_OPEN,h.DELETED,h.ID_MEDICAL_ORGANIZATION,h.ID_HOSPITAL_TAPE
order by case when H.ID_HOSPITAL_TAPE = (select HT.ID_HOSPITAL_TAPE from HOSPITAL_TAPE HT where HT.NAME_HOSPITAL_TAPE = 'Государственная')
            then 0
            else 1
        end desc,
         count(D.ID_DOCTOR) desc,
        H.IS_OPEN desc;
--4 *Исправил
select * from DOCTOR D
where D.DELETED is null and D.ID_HOSPITAL = 34
order by d.QUALIFICATION,
         case when D.AREA = 15 then 1
            else 0
        end;
--5 *Вроде исправил
select * from LEBEDEV_EG.DOCTOR_TIMETABLE dt
where dt.ID_DOCTOR = 1 and dt.TIME_SPACES_TO < sysdate and dt.TIME_SPACES_FROM < sysdate;
--6



--2.2,2.3
declare
    v_string_result varchar2(100);
    v_number_result integer;
begin
    select CITY_NAME into v_string_result from CITY where ID_CITY = 1;
    select ID_CITY into v_number_result from CITY where CITY_NAME = v_string_result;
    DBMS_OUTPUT.PUT_LINE(v_string_result );
end;

--2.4 ??
declare
    v_bool boolean;
    v_int integer;
begin
    v_bool := false;
    if(v_bool)
        then select ID_CITY into v_int from CITY where CITY_NAME = 'Кемерово';
        else select ID_REGION into v_int from REGION where NAME_REGION like 'Новосибирская область';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_int);
end;

--2.5
select * from LEBEDEV_EG.MEDICAL_ORGANIZATION;
declare
    v_date date;
    v_id_hospital number;
begin
    v_date = sysdate;
    select ID_HOSPITAL into v_id_hospital from HOSPITAL where DELETED = v_date;
    DBMS_OUTPUT.PUT_LINE(v_id_hospital);
    select ID_HOSPITAL into v_id_hospital from HOSPITAL where DELETED between v_date and v_date - 7;
    DBMS_OUTPUT.PUT_LINE(v_id_hospital);
end;
--2.6
declare
    v_city LEBEDEV_EG.city%rowtype;
begin
    select * into v_city from CITY where CITY_NAME = 'Кемерово';
    DBMS_OUTPUT.PUT_LINE(v_city.ID_REGION || '  ' || v_city.CITY_NAME);
end;

--2.7
declare
    type arr_type is table of LEBEDEV_EG.City%rowtype
    index by binary_integer;
    v_city arr_type;
    v_iterator binary_integer;
begin
    select * bulk collect into v_city from CITY ;
    v_iterator:= v_city.FIRST;
    while v_iterator <> v_city.LAST
    loop
        DBMS_OUTPUT.PUT_LINE(v_city(v_iterator).CITY_NAME);
        v_iterator:= v_city.NEXT(v_iterator);
        end loop;
end;
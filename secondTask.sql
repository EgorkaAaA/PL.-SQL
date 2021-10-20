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
--3
SELECT H.* from HOSPITAL H
inner join LEBEDEV_EG.DOCTOR D
on H.ID_HOSPITAL = D.ID_HOSPITAL
inner join LEBEDEV_EG.DOCTOR_SPECIALITY DS
on DS.ID_DOCTOR = D.ID_DOCTOR
where DS.ID_SPECIALITY = 2 and H.DELETED is null and D.DELETED is null
order by H.ID_HOSPITAL_TAPE,H.IS_OPEN desc;--, count(D.ID_DOCTOR),
--4






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
    select * into v_city from CITY where ID_CITY = 2;
    v_iterator:= v_city.FIRST;
    while v_iterator <> v_city.LAST
    loop
        DBMS_OUTPUT.PUT_LINE(v_city(v_iterator).CITY_NAME);
        v_iterator:= v_city.NEXT(v_iterator);
        end loop;
end;
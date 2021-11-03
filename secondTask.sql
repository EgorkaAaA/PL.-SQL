--1
select c.city_name, name_region
from city c
inner join region r on r.id_region = c.id_region;
--2
select s.name_speciality,s.id_age_group from lebedev_eg.speciality s
inner join lebedev_eg.doctor_speciality ds
on s.id_speciality = ds.id_speciality
inner join doctor d
on ds.id_doctor = d.id_doctor
inner join lebedev_eg.hospital h
on h.id_hospital = d.id_hospital
where s.deleted is null and d.deleted is null and h.deleted is null;
--3 *исправил
select count(d.id_doctor) as count, h.*  from hospital h
inner join lebedev_eg.doctor d
on h.id_hospital = d.id_hospital
inner join lebedev_eg.doctor_speciality ds
on ds.id_doctor = d.id_doctor
where ds.id_speciality = 2 and h.deleted is null and d.deleted is null
group by h.id_hospital, h.name_hospital,h.is_open,h.deleted,h.id_medical_organization,h.id_hospital_tape
order by case when h.id_hospital_tape = (select ht.id_hospital_tape from hospital_tape ht where ht.name_hospital_tape = 'государственная')
            then 0
            else 1
        end desc,
         count(d.id_doctor) desc,
        h.is_open desc;
--4 *исправил
select * from doctor d
where d.deleted is null and d.id_hospital = 34
order by d.qualification,
         case when d.area = 15 then 1
            else 0
        end;
--5 *вроде исправил
select * from lebedev_eg.doctor_timetable dt
where dt.id_doctor = 1 and dt.time_spaces_to < sysdate and dt.time_spaces_from < sysdate;
--6



--2.2,2.3
declare
    v_string_result varchar2(100);
    v_number_result integer;
begin
    select city_name into v_string_result from city where id_city = 1;
    select id_city into v_number_result from city where city_name = v_string_result;
    dbms_output.put_line(v_string_result );
end;

--2.4 ??
declare
    v_bool boolean;
    v_int integer;
begin
    v_bool := false;
    if(v_bool)
        then select id_city into v_int from city where city_name = 'кемерово';
        else select id_region into v_int from region where name_region like 'новосибирская область';
    end if;
    dbms_output.put_line(v_int);
end;

--2.5
select * from lebedev_eg.medical_organization;
declare
    v_date date;
    v_id_hospital number;
begin
    v_date = sysdate;
    select id_hospital into v_id_hospital from hospital where deleted = v_date;
    dbms_output.put_line(v_id_hospital);
    select id_hospital into v_id_hospital from hospital where deleted between v_date and v_date - 7;
    dbms_output.put_line(v_id_hospital);
end;
--2.6
declare
    v_city lebedev_eg.city%rowtype;
begin
    select * into v_city from city where city_name = 'кемерово';
    dbms_output.put_line(v_city.id_region || '  ' || v_city.city_name);
end;

--2.7
declare
    type arr_type is table of lebedev_eg.city%rowtype
    index by binary_integer;
    v_city arr_type;
    v_iterator binary_integer;
begin
    select * bulk collect into v_city from city ;
    v_iterator:= v_city.first;
    while v_iterator <> v_city.last
    loop
        dbms_output.put_line(v_city(v_iterator).city_name);
        v_iterator:= v_city.next(v_iterator);
        end loop;
end;
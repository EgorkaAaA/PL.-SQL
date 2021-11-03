insert into lebedev_eg.day_of_week(name_of_day)
values ('пн');
insert into lebedev_eg.day_of_week(name_of_day)
values ('вт');
insert into lebedev_eg.day_of_week(name_of_day)
values ('ср');
insert into lebedev_eg.day_of_week(name_of_day)
values ('чт');
insert into lebedev_eg.day_of_week(name_of_day)
values ('пт');
insert into lebedev_eg.day_of_week(name_of_day)
values ('сб');
insert into lebedev_eg.day_of_week(name_of_day)
values ('вс');

select * from day_of_week order by id_day;
-- delete from day_of_week where id_day = 6;

insert into lebedev_eg.sex(name_sex)
values ('мужчины'); --1
insert into lebedev_eg.sex(name_sex)
values ('женщины'); --2
insert into lebedev_eg.sex(name_sex)
values ('панзерфауст'); --3
insert into lebedev_eg.sex(name_sex)
values ('вертолет атакует'); --4
insert into lebedev_eg.sex(name_sex)
values ('общий'); --5

insert into lebedev_eg.age_group(min_age, max_age)
values (0,3); --1
insert into lebedev_eg.age_group(min_age, max_age)
values (4,6); --2
insert into lebedev_eg.age_group(min_age, max_age)
values (6,10); --3
insert into lebedev_eg.age_group(min_age, max_age)
values (10,17); --4
insert into lebedev_eg.age_group(min_age, max_age)
values (18,35); --5
insert into lebedev_eg.age_group(min_age, max_age)
values (36,60); --6
insert into lebedev_eg.age_group(min_age, max_age)
values (60,150); --7
insert into lebedev_eg.age_group(min_age, max_age)
values (0,18); --8
insert into lebedev_eg.age_group(min_age, max_age)
values (18,150); --9

insert into lebedev_eg.hospital_tape(name_hospital_tape)
values ('государтвенная'); --1
insert into lebedev_eg.hospital_tape(name_hospital_tape)
values ('частная'); --2

update lebedev_eg.hospital_tape set name_hospital_tape = 'государственная' where id_hospital_tape =1;

select * from speciality;
insert into lebedev_eg.speciality(name_speciality, id_age_group,  deleted)
values ('педиатр',8,null); --1
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (1,1);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (1,2);
insert into lebedev_eg.speciality(name_speciality, id_age_group,  deleted)
values ('врач для мальчиков от 0 до 3 лет',1,null); --2
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (2,1);
insert into lebedev_eg.speciality(name_speciality, id_age_group, deleted)
values ('врач для девочек от 4 до 6 лет',2,null); --3
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (3,2);
insert into lebedev_eg.speciality(name_speciality, id_age_group,  deleted)
values ('врач для детей от 6 до 10 лет',3,sysdate);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (4,1);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (4,2);
insert into lebedev_eg.speciality(name_speciality, id_age_group,  deleted)
values ('врач для детей от 10 до 17 лет',4,null);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (5,1);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (5,2);
insert into lebedev_eg.speciality(name_speciality, id_age_group,  deleted)
values ('врач для молодежи мужчин',5,null);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (6,1);
insert into lebedev_eg.speciality(name_speciality, id_age_group,  deleted)
values ('врач для женщин средних лет',6,null);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (7,2);
insert into lebedev_eg.speciality(name_speciality,id_age_group,  deleted)
values ('врач для детей панзерваустов',1,null);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (8,3);
insert into lebedev_eg.speciality(name_speciality,id_age_group,  deleted)
values ('врач для всех',9,null);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (9,1);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (9,2);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (9,3);
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (9,4);
insert into lebedev_eg.speciality(name_speciality, id_age_group, deleted)
values ('педиатр для атакующих вертолетов',9, to_date('2012-10-11 09:15:34', 'yyyy/mm/dd hh24:mi:ss'));
insert into lebedev_eg.speciality_sex(id_speciality, id_sex)
values (12,4);


insert into lebedev_eg.region (name_region)
values ('новосибирская область');
select * from region;

insert into city (city_name, id_region)
values ('новосибирск', 3);
insert into city (city_name, id_region)
values ('искитим', 3);
insert into city (city_name, id_region)
values ('прокопьевск', 1);
insert into city (city_name, id_region)
values ('белово', 1);
commit ;
select * from hospital;
declare
    v_id_med_org number;
    v_is_open number;
    v_deleted date;
    cursor select_id_hospital (
        v_hosp_tape_name in varchar2
        ) is
    select id_hospital_tape from lebedev_eg.hospital_tape
        where name_hospital_tape = v_hosp_tape_name;
    v_id_hosp_tape lebedev_eg.hospital_tape.id_hospital_tape%type;
begin
    open select_id_hospital('государтвенная');
    insert into medical_organization (name_medical_organization)
    values ('государтвенная')
    returning id_medical_organization into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null; dbms_output.put_line('tyt');
        end if;
        fetch select_id_hospital into v_id_hosp_tape;
        dbms_output.put_line(v_id_hosp_tape);
        insert into lebedev_eg.hospital(name_hospital, is_open, deleted, id_medical_organization, id_hospital_tape)
        values ('поликлиника №'||i, v_is_open,null,v_id_med_org,v_id_hosp_tape);
        end loop;
     insert into medical_organization (name_medical_organization)
    values ('лучшая')
    returning id_medical_organization into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into lebedev_eg.hospital(name_hospital, is_open, deleted, id_medical_organization, id_hospital_tape)
        values ('больница №'||i, v_is_open,v_deleted,v_id_med_org, v_id_hosp_tape);
        end loop;
    insert into medical_organization (name_medical_organization)
    values ('худшая')
    returning id_medical_organization into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into lebedev_eg.hospital(name_hospital, is_open, deleted, id_medical_organization, id_hospital_tape)
        values ('диспансер №'||i, v_is_open,v_deleted,v_id_med_org, v_id_hosp_tape);
        end loop;
    close select_id_hospital;
    open select_id_hospital('частная');
    fetch select_id_hospital into v_id_hosp_tape;
    insert into medical_organization (name_medical_organization)
    values ('инвитро')
    returning id_medical_organization into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into lebedev_eg.hospital(name_hospital, is_open, deleted, id_medical_organization, id_hospital_tape)
        values ('инвитро №'||i, v_is_open,v_deleted,v_id_med_org,v_id_hosp_tape);
        end loop;
    insert into medical_organization (name_medical_organization)
    values ('медлайн')
    returning id_medical_organization into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into lebedev_eg.hospital(name_hospital, is_open, deleted, id_medical_organization, id_hospital_tape)
        values ('поликлиника №'||i, v_is_open,v_deleted,v_id_med_org, v_id_hosp_tape);
        end loop;
    close select_id_hospital;
end;

insert into lebedev_eg.doctor(id_hospital, area, qualification, deleted)
values (1,10,'что-то квалифицированное',null);
insert into lebedev_eg.doctor(id_hospital, area, qualification, deleted)
values (1,20,'что-то квалифицированное',sysdate);
insert into lebedev_eg.doctor(id_hospital, area, qualification, deleted)
values (1,30,'что-то квалифицированное',null);
insert into lebedev_eg.doctor(id_hospital, area, qualification, deleted)
values (1,40,'что-то квалифицированное',null);
insert into lebedev_eg.doctor(id_hospital, area, qualification, deleted)
values (2,50,'что-то квалифицированное',null);
insert into lebedev_eg.doctor(id_hospital, area, qualification, deleted)
values (2,10,'что-то квалифицированное',null);

select * from speciality;
select * from hospital;
select count(doctor.id_doctor) as count from doctor ;
select count(doctor_speciality.id_doctor) as count from doctor_speciality;
commit ;
declare
    v_deleted date;
    v_id_doctor number;
    v_id_speciality number;
    v_id_hosp number;
    v_area number;
    v_qualif varchar2(100);
begin
    for i in 1..1300
    loop
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted:= null;
        end if;
        v_id_hosp := round(dbms_random.value(19,118));
        v_area := round(dbms_random.value(0,100));
        v_qualif := dbms_random.string('u', 10);
        insert into lebedev_eg.doctor(id_hospital, area, qualification, deleted)
            values (v_id_hosp,v_area,v_qualif, v_deleted)
        returning id_doctor into v_id_doctor;
        loop
            v_id_speciality := round(dbms_random.value(1,22));
            exit when v_id_speciality <= 9 or v_id_speciality >= 12;
        end loop;
        insert into lebedev_eg.doctor_speciality(id_doctor, id_speciality)
            values (v_id_doctor, v_id_speciality);
        end loop;
end;

insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
values (1,2, to_date('08:00','hh24:mi'),sysdate);
insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
values (1,3, to_date('08:00','hh24:mi'),sysdate);
insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
values (1,4, to_date('08:00','hh24:mi'),sysdate);
insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
values (1,5, to_date('08:00','hh24:mi'),sysdate);
insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
values (1,6, to_date('08:00','hh24:mi'),sysdate);
insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
values (1,7, to_date('08:00','hh24:mi'),sysdate);
insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
values (1,8, to_date('08:00','hh24:mi'),sysdate);


insert into lebedev_eg.doctor_speciality(id_doctor, id_speciality)
values (1,2);
insert into lebedev_eg.doctor_speciality(id_doctor, id_speciality)
values (2,3);

insert into lebedev_eg.doctor_speciality(id_doctor, id_speciality)
values (3,4);
insert into lebedev_eg.doctor_speciality(id_doctor, id_speciality)
values (4,3);
insert into lebedev_eg.doctor_speciality(id_doctor, id_speciality)
values (2,2);

select * from sex;

insert into document(name)
    values ('паспорт');
insert into document(name)
    values ('инн');
insert into document(name)
    values ('снилс');
insert into document(name)
    values ('полис');
insert into document(name)
    values ('омс');
select * from document;

declare
    v_patronumic varchar2(100);
    v_id_patient number;
begin
    for i in 1..6000
    loop
        if round(dbms_random.value(1,10)) > 5 then v_patronumic := null;
        else v_patronumic := dbms_random.string('u',round(dbms_random.value(1,20)) );
        end if;
        insert into lebedev_eg.patient(surname, name, patronymic, id_sex, phone, area)
        values (dbms_random.string('u',dbms_random.value(2,20)),dbms_random.string('u',dbms_random.value(2,20)),v_patronumic,floor(dbms_random.value(1,5)),
            null, round(dbms_random.value(1,100)))
        returning patient.id_patient into v_id_patient;
        for ii in 5..9
        loop
            insert into patient_document (id_patient, id_document, value)
            values (v_id_patient,ii,round(dbms_random.value(100000,1000000)));
        end loop;
        end loop;
end;

commit ;


update patient set patient.phone = round(dbms_random.value(80000000000,89999999999)) where phone is not null;

select * from lebedev_eg.patient;

select * from lebedev_eg.hospital_timetable;
begin
    for i in (select lebedev_eg.hospital.id_hospital from lebedev_eg.hospital )
    loop
        for ii in (select dw.id_day from lebedev_eg.day_of_week dw order by dw.id_day)
        loop
            insert into lebedev_eg.hospital_timetable(id_hospital, id_day, start_work_time, finish_work_time)
            values (i.id_hospital, ii.id_day, to_date('08:00','hh24:mi'), to_date('17:00','hh24:mi'));
            end loop;
        end loop;
end;

select * from doctor_timetable;


begin
    for i in 0..100
    loop
        dbms_output.put_line(to_char(to_date('29/10/21 08:00', 'dd/mm/yy hh24:mi') + i,'dd/mm/yy hh24:mi'));
        end loop;
end;
declare
    inerator number := 0;
begin
    for i in (select d.id_doctor from lebedev_eg.doctor d)
    loop
        insert into lebedev_eg.doctor_timetable(id_doctor, time_spaces_from, time_spaces_to, is_open)
        values (i.id_doctor,to_date('29/10/21 08:00', 'dd/mm/yy hh24:mi') + inerator,to_date('29/10/21 10:00', 'dd/mm/yy hh24:mi') + inerator,1);
        insert into lebedev_eg.doctor_timetable(id_doctor, time_spaces_from, time_spaces_to, is_open)
        values (i.id_doctor,to_date('29/10/21 10:20', 'dd/mm/yy hh24:mi') + inerator,to_date('29/10/21 12:20', 'dd/mm/yy hh24:mi') + inerator,1);
        insert into lebedev_eg.doctor_timetable(id_doctor, time_spaces_from, time_spaces_to, is_open)
        values (i.id_doctor,to_date('29/10/21 12:40', 'dd/mm/yy hh24:mi') + inerator,to_date('29/10/21 14:40', 'dd/mm/yy hh24:mi') + inerator,1);
        insert into lebedev_eg.doctor_timetable(id_doctor, time_spaces_from, time_spaces_to, is_open)
        values (i.id_doctor,to_date('29/10/21 15:00', 'dd/mm/yy hh24:mi') + inerator,to_date('29/10/21 17:00', 'dd/mm/yy hh24:mi') + inerator,1);
        inerator := inerator + 1;
        end loop;
end;

select * from doctor_timetable;
commit;
SELECT * FROM DOCTOR;



select * from lebedev_eg.doctor_timetable dt
         where
              (8 is null or dt.id_doctor = 1);

--        and       (dt.time_spaces_to < sysdate and dt.time_spaces_from < sysdate);

select ID_DOCTOR     from DOCTOR order by ID_DOCTOR


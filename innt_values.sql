insert into LEBEDEV_EG.DAY_OF_WEEK(NAME_OF_DAY)
values ('ПН');
insert into LEBEDEV_EG.DAY_OF_WEEK(NAME_OF_DAY)
values ('ВТ');
insert into LEBEDEV_EG.DAY_OF_WEEK(NAME_OF_DAY)
values ('СР');
insert into LEBEDEV_EG.DAY_OF_WEEK(NAME_OF_DAY)
values ('ЧТ');
insert into LEBEDEV_EG.DAY_OF_WEEK(NAME_OF_DAY)
values ('ПТ');
insert into LEBEDEV_EG.DAY_OF_WEEK(NAME_OF_DAY)
values ('СБ');
insert into LEBEDEV_EG.DAY_OF_WEEK(NAME_OF_DAY)
values ('ВС');

select * from DAY_OF_WEEK order by ID_DAY;
-- delete from DAY_OF_WEEK where ID_DAY = 6;

insert into LEBEDEV_EG.SEX(NAME_SEX)
values ('Мужчины'); --1
insert into LEBEDEV_EG.SEX(NAME_SEX)
values ('Женщины'); --2
insert into LEBEDEV_EG.SEX(NAME_SEX)
values ('Панзерфауст'); --3
insert into LEBEDEV_EG.SEX(NAME_SEX)
values ('Вертолет атакует'); --4
insert into LEBEDEV_EG.SEX(NAME_SEX)
values ('Общий'); --5

insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (0,3); --1
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (4,6); --2
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (6,10); --3
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (10,17); --4
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (18,35); --5
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (36,60); --6
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (60,150); --7
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (0,18); --8
insert into LEBEDEV_EG.AGE_GROUP(MIN_AGE, MAX_AGE)
values (18,150); --9

insert into LEBEDEV_EG.HOSPITAL_TAPE(NAME_HOSPITAL_TAPE)
values ('Государтвенная'); --1
insert into LEBEDEV_EG.HOSPITAL_TAPE(NAME_HOSPITAL_TAPE)
values ('Частная'); --2

UPDATE LEBEDEV_EG.HOSPITAL_TAPE set NAME_HOSPITAL_TAPE = 'Государственная' where ID_HOSPITAL_TAPE =1;

select * from SPECIALITY;
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP,  DELETED)
values ('Педиатр',8,null); --1
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (1,1);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (1,2);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP,  DELETED)
values ('Врач для мальчиков от 0 до 3 лет',1,null); --2
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (2,1);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP, DELETED)
values ('Врач для девочек от 4 до 6 лет',2,null); --3
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (3,2);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP,  DELETED)
values ('Врач для детей от 6 до 10 лет',3,sysdate);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (4,1);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (4,2);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP,  DELETED)
values ('Врач для детей от 10 до 17 лет',4,null);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (5,1);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (5,2);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP,  DELETED)
values ('Врач для молодежи мужчин',5,null);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (6,1);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP,  DELETED)
values ('Врач для женщин средних лет',6,null);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (7,2);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY,ID_AGE_GROUP,  DELETED)
values ('Врач для детей панзерваустов',1,null);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (8,3);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY,ID_AGE_GROUP,  DELETED)
values ('Врач для всех',9,null);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (9,1);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (9,2);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (9,3);
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (9,4);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, ID_AGE_GROUP, DELETED)
values ('Педиатр для атакующих вертолетов',9, to_date('2012-10-11 09:15:34', 'yyyy/mm/dd hh24:mi:ss'));
insert into LEBEDEV_EG.SPECIALITY_SEX(ID_SPECIALITY, ID_SEX)
values (12,4);


insert into LEBEDEV_EG.REGION (NAME_REGION)
values ('Новосибирская область');
select * from REGION;

insert into CITY (CITY_NAME, ID_REGION)
values ('Новосибирск', 3);
insert into CITY (CITY_NAME, ID_REGION)
values ('Искитим', 3);
insert into CITY (CITY_NAME, ID_REGION)
values ('Прокопьевск', 1);
insert into CITY (CITY_NAME, ID_REGION)
values ('Белово', 1);
commit ;
select * from HOSPITAL;
declare
    v_id_med_org number;
    v_is_open number;
    v_deleted date;
    cursor select_id_hospital (
        v_hosp_tape_name in varchar2
        ) is
    select ID_HOSPITAL_TAPE from LEBEDEV_EG.HOSPITAL_TAPE
        where NAME_HOSPITAL_TAPE = v_hosp_tape_name;
    v_id_hosp_tape LEBEDEV_EG.HOSPITAL_TAPE.ID_HOSPITAL_TAPE%type;
begin
    open select_id_hospital('Государтвенная');
    insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
    values ('Государтвенная')
    returning ID_MEDICAL_ORGANIZATION into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null; DBMS_OUTPUT.PUT_LINE('tyt');
        end if;
        fetch select_id_hospital into v_id_hosp_tape;
        DBMS_OUTPUT.PUT_LINE(v_id_hosp_tape);
        insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
        values ('Поликлиника №'||i, v_is_open,null,v_id_med_org,v_id_hosp_tape);
        end loop;
     insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
    values ('Лучшая')
    returning ID_MEDICAL_ORGANIZATION into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
        values ('Больница №'||i, v_is_open,v_deleted,v_id_med_org, v_id_hosp_tape);
        end loop;
    insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
    values ('Худшая')
    returning ID_MEDICAL_ORGANIZATION into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
        values ('Диспансер №'||i, v_is_open,v_deleted,v_id_med_org, v_id_hosp_tape);
        end loop;
    close select_id_hospital;
    open select_id_hospital('Частная');
    fetch select_id_hospital into v_id_hosp_tape;
    insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
    values ('Инвитро')
    returning ID_MEDICAL_ORGANIZATION into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
        values ('Инвитро №'||i, v_is_open,v_deleted,v_id_med_org,v_id_hosp_tape);
        end loop;
    insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
    values ('Медлайн')
    returning ID_MEDICAL_ORGANIZATION into v_id_med_org;
    for i in 1..20
    loop
        if mod(i,3) = 0 then v_is_open := 0;
        else v_is_open := 1;
        end if;
        if mod(i,5) = 0 then v_deleted := sysdate;
        else v_deleted := null;
        end if;
        insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
        values ('Поликлиника №'||i, v_is_open,v_deleted,v_id_med_org, v_id_hosp_tape);
        end loop;
    close select_id_hospital;
end;

insert into LEBEDEV_EG.DOCTOR(ID_HOSPITAL, AREA, QUALIFICATION, DELETED)
VALUES (1,10,'Что-то квалифицированное',null);
insert into LEBEDEV_EG.DOCTOR(ID_HOSPITAL, AREA, QUALIFICATION, DELETED)
VALUES (1,20,'Что-то квалифицированное',sysdate);
insert into LEBEDEV_EG.DOCTOR(ID_HOSPITAL, AREA, QUALIFICATION, DELETED)
VALUES (1,30,'Что-то квалифицированное',null);
insert into LEBEDEV_EG.DOCTOR(ID_HOSPITAL, AREA, QUALIFICATION, DELETED)
VALUES (1,40,'Что-то квалифицированное',null);
insert into LEBEDEV_EG.DOCTOR(ID_HOSPITAL, AREA, QUALIFICATION, DELETED)
VALUES (2,50,'Что-то квалифицированное',null);
insert into LEBEDEV_EG.DOCTOR(ID_HOSPITAL, AREA, QUALIFICATION, DELETED)
VALUES (2,10,'Что-то квалифицированное',null);

select * from SPECIALITY;
select * from HOSPITAL;
select count(DOCTOR.ID_DOCTOR) as COUNT from DOCTOR ;
select count(DOCTOR_SPECIALITY.ID_DOCTOR) as count from DOCTOR_SPECIALITY;
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
        v_id_hosp := round(DBMS_RANDOM.VALUE(19,118));
        v_area := round(DBMS_RANDOM.VALUE(0,100));
        v_qualif := dbms_random.string('U', 10);
        insert into LEBEDEV_EG.DOCTOR(ID_HOSPITAL, AREA, QUALIFICATION, DELETED)
            values (v_id_hosp,v_area,v_qualif, v_deleted)
        returning ID_DOCTOR into v_id_doctor;
        loop
            v_id_speciality := round(DBMS_RANDOM.VALUE(1,22));
            exit when v_id_speciality <= 9 or v_id_speciality >= 12;
        end loop;
        insert into LEBEDEV_EG.DOCTOR_SPECIALITY(ID_DOCTOR, ID_SPECIALITY)
            values (v_id_doctor, v_id_speciality);
        end loop;
end;

insert into LEBEDEV_EG.HOSPITAL_TIMETABLE(ID_HOSPITAL, ID_DAY, START_WORK_TIME, FINISH_WORK_TIME)
VALUES (1,2, to_date('08:00','hh24:MI'),sysdate);
insert into LEBEDEV_EG.HOSPITAL_TIMETABLE(ID_HOSPITAL, ID_DAY, START_WORK_TIME, FINISH_WORK_TIME)
VALUES (1,3, to_date('08:00','hh24:MI'),sysdate);
insert into LEBEDEV_EG.HOSPITAL_TIMETABLE(ID_HOSPITAL, ID_DAY, START_WORK_TIME, FINISH_WORK_TIME)
VALUES (1,4, to_date('08:00','hh24:MI'),sysdate);
insert into LEBEDEV_EG.HOSPITAL_TIMETABLE(ID_HOSPITAL, ID_DAY, START_WORK_TIME, FINISH_WORK_TIME)
VALUES (1,5, to_date('08:00','hh24:MI'),sysdate);
insert into LEBEDEV_EG.HOSPITAL_TIMETABLE(ID_HOSPITAL, ID_DAY, START_WORK_TIME, FINISH_WORK_TIME)
VALUES (1,6, to_date('08:00','hh24:MI'),sysdate);
insert into LEBEDEV_EG.HOSPITAL_TIMETABLE(ID_HOSPITAL, ID_DAY, START_WORK_TIME, FINISH_WORK_TIME)
VALUES (1,7, to_date('08:00','hh24:MI'),sysdate);
insert into LEBEDEV_EG.HOSPITAL_TIMETABLE(ID_HOSPITAL, ID_DAY, START_WORK_TIME, FINISH_WORK_TIME)
VALUES (1,8, to_date('08:00','hh24:MI'),sysdate);


insert into LEBEDEV_EG.DOCTOR_SPECIALITY(ID_DOCTOR, ID_SPECIALITY)
VALUES (1,2);
insert into LEBEDEV_EG.DOCTOR_SPECIALITY(ID_DOCTOR, ID_SPECIALITY)
VALUES (2,3);

insert into LEBEDEV_EG.DOCTOR_SPECIALITY(ID_DOCTOR, ID_SPECIALITY)
VALUES (3,4);
insert into LEBEDEV_EG.DOCTOR_SPECIALITY(ID_DOCTOR, ID_SPECIALITY)
VALUES (4,3);
insert into LEBEDEV_EG.DOCTOR_SPECIALITY(ID_DOCTOR, ID_SPECIALITY)
VALUES (2,2);


insert into LEBEDEV_EG.PATIENT(SURNAME, NAME, PATRONYMIC, ID_SEX, PHONE, AREA)
values
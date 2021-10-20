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

insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
values ('Государственная');
insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
values ('Инвитро');
insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
values ('Медлайн');
insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
values ('Лучшая');
insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
values ('Худшая');

insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
VALUES ('Областная больница №1', 1, null, 1,1);
insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
VALUES ('Областная больница №2', 1, sysdate, 1,1);
insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
VALUES ('Инвитро №1', 1, null, 2,2);
insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
VALUES ('Медлайн №1', 1, null, 3,2);
insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
VALUES ('Областная больница №1', 1, null, 4,2);
insert into LEBEDEV_EG.HOSPITAL(NAME_HOSPITAL, IS_OPEN, DELETED, ID_MEDICAL_ORGANIZATION, ID_HOSPITAL_TAPE)
VALUES ('Областная больница №1', 0, null, 5,1);

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

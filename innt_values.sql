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

insert into LEBEDEV_EG.DOCUMENT(NAME_DOCUMENT)
values ('Свидетельство о рождении'); --1
insert into LEBEDEV_EG.DOCUMENT(NAME_DOCUMENT)
values ('Паспорт'); --2
insert into LEBEDEV_EG.DOCUMENT(NAME_DOCUMENT)
values ('Снилс'); --3
insert into LEBEDEV_EG.DOCUMENT(NAME_DOCUMENT)
values ('Медицинский полис'); --4

insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Педиатр',8,5,null); --1
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для мальчиков от 0 до 3 лет',1,1,null); --2
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для девочек от 4 до 6 лет',2,2,null); --3
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для детей от 6 до 10 лет',3,5,sysdate);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для детей от 10 до 17 лет',4,5,null);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для молодежи мужчин',5,1,null);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для женщин средних лет',6,5,null);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для детей панзерваустов',1,3,null);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Врач для всех',9,5,null);
insert into LEBEDEV_EG.SPECIALITY(NAME_SPECIALITY, AGE_GROUP, SEX, DELETED)
values ('Педиатр для атакующих вертолетов',9,4, to_date('2012-10-11 09:15:34', 'yyyy/mm/dd hh24:mi:ss'));


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
values ('Государственная');
insert into MEDICAL_ORGANIZATION (NAME_MEDICAL_ORGANIZATION)
values ('Государственная');

create table lebedev_eg.region (
    id_region number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocache nocycle noorder) primary key,
    name_region varchar(100) unique not null
);

create table lebedev_eg.city (
    id_city number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    city_name varchar(100) unique not null ,
    id_region number references lebedev_eg.region(id_region) not null
);

create table lebedev_eg.medical_organization (
    id_medical_organization number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocache nocycle noorder) primary key,
    name_medical_organization varchar(100) unique not null
);

create table lebedev_eg.city_medical_organization (
    id_city number references lebedev_eg.city(id_city),
    id_medical_organization number references lebedev_eg.medical_organization(id_medical_organization),
    primary key (id_city,id_medical_organization)
);

create table lebedev_eg.hospital_tape (
    id_hospital_tape number generated by default as identity
        (start with 1 maxvalue 5 minvalue 1 nocache nocycle noorder) primary key,
    name_hospital_tape varchar(100) not null unique
);

create table lebedev_eg.day_of_week (
    id_day number generated by default as identity
        (start with 1 maxvalue 7 minvalue 1 nocycle nocache noorder) primary key,
    name_of_day varchar(2) unique not null
);

create table lebedev_eg.hospital(
    id_hospital number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    name_hospital varchar(100) not null,
    is_open number(1,0) not null,
    deleted date null
);

create table lebedev_eg.hospital_timetable (
    id_hospital_timetable number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    id_hospital number references lebedev_eg.hospital(id_hospital),
    id_day number references lebedev_eg.day_of_week(id_day) not null,
    start_work_time date not null,
    finish_work_time date not null
);

create table lebedev_eg.speciality (
    id_speciality number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    name_speciality varchar(100) not null,
    age_group number references lebedev_eg.age_group(id_age_group) not null,
    sex number references lebedev_eg.sex(id_sex) not null,
    deleted date null
);

create table lebedev_eg.age_group (
    id_age_group number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    min_age number not null,
    max_age number not null
);

create table lebedev_eg.sex(
    id_sex number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    name_sex varchar(100) not null
);

create table lebedev_eg.doctor (
    id_doctor number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    id_hospital number references lebedev_eg.hospital(id_hospital) not null,
    area number not null,
    qualification varchar(100) not null,
    deleted date null
);

create table lebedev_eg.doctor_timetable(
    id_timetable number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    id_doctor number references lebedev_eg.doctor(id_doctor) not null,
    time_spaces_from date not null,
    time_spaces_to date not null,
    is_open number(1,0) not null
);

create table lebedev_eg.patient (
    id_patient number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    surname varchar(100) not null,
    name varchar(100) not null,
    patronymic varchar(100) null,
    sex number references lebedev_eg.sex(id_sex) not null,
    phone number null,
    area number not null
);

create table lebedev_eg.journal (
    id_patient number references lebedev_eg.patient(id_patient) not null,
    id_talon number references lebedev_eg.doctor_timetable(id_timetable) not null,
    primary key (id_patient,id_talon),
    available number (1,0) not null
);

--???????????? ?????? ????????????????
alter table hospital
    add id_medical_organization number references lebedev_eg.medical_organization(id_medical_organization) not null;
alter table hospital
    add id_hospital_tape number references lebedev_eg.hospital_tape(id_hospital_tape) not null;
alter table hospital_timetable
    modify id_hospital  not null;

create table lebedev_eg.doctor_speciality (
    id_doctor number references lebedev_eg.doctor(id_doctor) not null,
    id_speciality number references lebedev_eg.speciality(id_speciality) not null,
    primary key(id_doctor,id_speciality)
);

alter table day_of_week
    modify id_day number generated by default as identity (start with 1 minvalue 1 maxvalue 50 nocycle nocache noorder);

create table lebedev_eg.account (
    id number generated by default as identity (start with 1 minvalue 1 maxvalue 50 nocycle nocache noorder) primary key,
    name varchar(100) not null,
    password varchar(100) not null
);


alter table lebedev_eg.patient
    add id_account number references account(id);
alter table lebedev_eg.patient
    rename column sex to id_sex;
alter table lebedev_eg.speciality
    rename column age_group to id_age_group;
alter table lebedev_eg.speciality
    rename column sex to id_sex;

create table  lebedev_eg.passport (
    id_passport number primary key,
    series number not null
);

create table lebedev_eg.sneels (
    id_sneels number primary key
);

create table lebedev_eg.inn (
    id_inn number primary key
);

create table lebedev_eg.patient_documents (
    id_patient number references lebedev_eg.patient(id_patient),
    id_passport number references lebedev_eg.passport(id_passport),
    id_sneels number references lebedev_eg.sneels(id_sneels),
    id_inn number references lebedev_eg.inn(id_inn),
    primary key (id_patient,id_passport,id_sneels, id_inn)
);

alter table lebedev_eg.speciality
    drop column id_sex;

create table lebedev_eg.speciality_sex(
    id_speciality number references lebedev_eg.speciality,
    id_sex number references lebedev_eg.sex,
    primary key (id_speciality, id_sex)
);

create table document (
  id_document number generated by default as identity primary key,
  name varchar2(100)
);


create table patient_document(
    id_patient number references lebedev_eg.patient(id_patient),
    id_document number references lebedev_eg.document(id_document),
    value varchar2(1000000),
    primary key (id_patient,id_document)
);
alter table patient_document
    modify value  number;
select d.name, pd.value, p.surname from document d
inner join patient_document pd
    on d.id_document = pd.id_document
inner join patient p
    on pd.id_patient = p.id_patient;


alter table LEBEDEV_EG.PATIENT
    add birthday date ;

update LEBEDEV_EG.PATIENT
set LEBEDEV_EG.PATIENT.birthday = (sysdate - DBMS_RANDOM.VALUE(0,25550))
where LEBEDEV_EG.PATIENT.birthday is null;

select P.birthday from PATIENT P;

begin
    DBMS_OUTPUT.PUT_LINE(sysdate - DBMS_RANDOM.VALUE(0,25550));
end;


alter table journal
    add rating number null check ( rating >= 0 and rating <= 10);

select * from journal;
create table LEBEDEV_EG.REGION (
    id_region number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocache nocycle noorder) primary key,
    name_region varchar(100) unique not null
);

create table LEBEDEV_EG.city (
    id_city number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    city_name varchar(100) unique not null ,
    id_region number references LEBEDEV_EG.REGION(id_region) not null
);

create table LEBEDEV_EG.Medical_organization (
    id_medical_organization number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocache nocycle noorder) primary key,
    name_medical_organization varchar(100) unique not null
);

create table LEBEDEV_EG.city_medical_organization (
    id_city number references LEBEDEV_EG.CITY(id_city),
    id_medical_organization number references LEBEDEV_EG.MEDICAL_ORGANIZATION(ID_MEDICAL_ORGANIZATION),
    primary key (id_city,id_medical_organization)
);

create table LEBEDEV_EG.hospital_tape (
    id_hospital_tape number generated by default as identity
        (start with 1 maxvalue 5 minvalue 1 nocache nocycle noorder) primary key,
    name_hospital_tape varchar(100) not null unique
);

create table LEBEDEV_EG.day_of_week (
    id_day number generated by default as identity
        (start with 1 maxvalue 7 minvalue 1 nocycle nocache noorder) primary key,
    name_of_day varchar(2) unique not null
);

create table LEBEDEV_EG.hospital(
    id_hospital number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    name_hospital varchar(100) not null,
    is_open number(1,0) not null,
    deleted date null
);

create table LEBEDEV_EG.hospital_timetable (
    id_hospital_timetable number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    id_hospital number references LEBEDEV_EG.hospital(id_hospital),
    id_day number references LEBEDEV_EG.day_of_week(id_day) not null,
    start_work_time date not null,
    finish_work_time date not null
);

create table LEBEDEV_EG.speciality (
    id_speciality number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    name_speciality varchar(100) not null,
    age_group number references LEBEDEV_EG.AGE_GROUP(id_age_group),
    sex number references LEBEDEV_EG.sex(id_sex),
    deleted date null
);

create table LEBEDEV_EG.age_group (
    id_age_group number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    min_age number not null,
    max_age number not null
);

create table LEBEDEV_EG.sex(
    id_sex number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    name_sex varchar(100) not null
);

create table LEBEDEV_EG.doctor (
    id_doctor number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    id_hospital number references LEBEDEV_EG.hospital(id_hospital) not null,
    area number not null,
    qualification varchar(100) not null,
    deleted date null
);

create table LEBEDEV_EG.doctor_timetable(
    id_timetable number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocycle nocache noorder) primary key,
    id_doctor number references LEBEDEV_EG.doctor(id_doctor) not null,
    time_spaces_from date not null,
    time_spaces_to date not null,
    is_open number(1,0) not null
)
-- использование getter'ов сущностей и именнованых в них конструкоров

-- создание конструкторов


-- конструктор для специальности:
alter type lebedev_eg.t_speciality
add constructor function t_speciality (
    id_speciality number,
    name_speciality varchar,
    id_age_group number,
    deleted date default null
)
return self as result
cascade;

create or replace type body lebedev_eg.t_speciality
as
    constructor function t_speciality(
        id_speciality number,
        name_speciality varchar,
        id_age_group number,
        deleted date default null
    )
    return self as result
    as
    begin
        if id_speciality is not null and not lebedev_eg.speciality_package.speciality_exists(id_speciality) then
            raise lebedev_eg.exceptions.speciality_not_exists;
        end if;
        if id_age_group is not null and not lebedev_eg.speciality_package.age_group_exists(id_age_group) then
            raise lebedev_eg.exceptions.age_group_not_exists;
        end if;

        self.id_speciality := id_speciality;
        self.name_speciality := name_speciality;
        self.id_age_group := id_age_group;
        self.deleted := deleted;
        return ;
    end;
end;

-- конструктор для пациентов:
alter type lebedev_eg.t_patient
add constructor function t_patient (
    id_patient number,
    surname varchar,
    name varchar,
    patronumic varchar default null,
    id_sex number,
    phone number default null,
    area number,
    birthday date
)
return self as result
cascade;

create type body lebedev_eg.t_patient
as
    constructor function t_patient (
        id_patient number,
        surname varchar,
        name varchar,
        patronumic varchar default null,
        id_sex number,
        phone number default null,
        area number,
        birthday date
    )
    return self as result
    as
    begin
        if id_patient is not null and not lebedev_eg.patient_package.patient_exists_as_func(id_patient) then
            raise lebedev_eg.exceptions.patient_not_exists;
        end if;
        if id_sex is not null and not lebedev_eg.sex_package.sex_exists_as_func(id_sex) then
            raise lebedev_eg.exceptions.sex_not_exists;
        end if;
        if phone is not null and not regexp_like(phone, '^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$') then
            raise lebedev_eg.exceptions.phone_number_not_valid;
        end if;

        self.id_patient := id_patient;
        self.surname := surname;
        self.name := name;
        self.patronumic := patronumic;
        self.id_sex := id_sex;
        self.phone := phone;
        self.area := area;
        self.birthday := birthday;

        return ;
    end;
end;

-- созадние конструктора для документов пациента
alter type lebedev_eg.t_patient_document
add constructor function t_patient_document (
    id_patient number,
    id_document number,
    value varchar
)
return self as result
cascade;

create type body lebedev_eg.t_patient_document
as
    constructor function t_patient_document (
        id_patient number,
        id_document number,
        value varchar
    )
    return self as result
    as
    begin
        if id_patient is not null and not lebedev_eg.patient_package.patient_exists_as_func(id_patient) then
            raise lebedev_eg.exceptions.patient_not_exists;
        end if;

        if id_document is not null and not lebedev_eg.document_package.document_is_exists_as_func(id_document) then
            raise lebedev_eg.exceptions.document_not_exists;
        end if;

        self.id_patient := id_patient;
        self.id_patient := id_patient;
        self.value := value;

        return ;
    end;
end;

-- конструктор для доктора
alter type lebedev_eg.t_doctor
add constructor function t_doctor (
    id_doctor number,
    id_hospital number,
    area number,
    qualification varchar,
    deleted date default null
)
return self as result
cascade;

create or replace type body lebedev_eg.t_doctor
as
    constructor function t_doctor (
        id_doctor number,
        id_hospital number,
        area number,
        qualification varchar,
        deleted date default null
    )
    return self as result
    as
    begin
        if id_doctor is not null and not lebedev_eg.doctor_package.doctor_is_exist_as_func(id_doctor) then
            raise lebedev_eg.exceptions.doctor_not_exists;
        end if;
        if id_hospital is not null and not lebedev_eg.hospital_paket.hospital_is_exist_as_func(id_hospital) then
            raise lebedev_eg.exceptions.hospital_not_exists;
        end if;

        self.id_doctor := id_doctor;
        self.id_hospital := id_hospital;
        self.area := area;
        self.qualification := qualification;
        self.deleted := deleted;

        return ;
    end;
end;

-- конструктор для больницы:
alter type lebedev_eg.t_hospital
add constructor function t_hospital (
    id_hospital number,
    name_hospital varchar,
    is_open number,
    id_medical_organization number,
    id_hospital_tape number,
    deleted date default null
)
return self as result
cascade;

create or replace type body lebedev_eg.t_hospital
as
    constructor function t_hospital (
        id_hospital number,
        name_hospital varchar,
        is_open number,
        id_medical_organization number,
        id_hospital_tape number,
        deleted date default null
    )
    return self as result
    as
    begin
        if id_hospital is not null and not lebedev_eg.hospital_paket.hospital_is_exist_as_func(id_hospital) then
            raise lebedev_eg.exceptions.hospital_not_exists;
        end if;
        if id_medical_organization is not null and not LEBEDEV_EG.HOSPITAL_PAKET.MEDICAL_ORGANIZATION_IS_EXIST_AS_FUNC(id_medical_organization) then
            raise LEBEDEV_EG.EXCEPTIONS.MEDICAL_ORGANIZATION_NOT_EXISTS;
        end if;
        if id_hospital_tape is not null and not LEBEDEV_EG.HOSPITAL_PAKET.HOSPITAL_TAPE_IS_EXIST_AS_FUNC(id_hospital_tape) then
            raise LEBEDEV_EG.EXCEPTIONS.HOSPITAL_TAPE_NOT_EXISTS;
        end if;

        SELF.ID_HOSPITAL := id_hospital;
        SELF.NAME_HOSPITAL := name_hospital;
        SELF.IS_OPEN := is_open;
        self.id_medical_organization := id_medical_organization;
        SELF.ID_HOSPITAL_TAPE := id_hospital_tape;
        self.DELETED := deleted;

        return ;
    end;
end;

-- конструктор для расписания больницы
alter type LEBEDEV_EG.T_HOSPITAL_TIME_TABLE
add constructor function t_hospital_time_table (
    id_hospital_timetable number,
    id_hospital number,
    id_day number,
    start_work_time date,
    finish_work_time date
)
return self as result
cascade;

create or replace type body LEBEDEV_EG.T_HOSPITAL_TIME_TABLE
as
    constructor function t_hospital_time_table (
        id_hospital_timetable number,
        id_hospital number,
        id_day number,
        start_work_time date,
        finish_work_time date
    )
    return self as result
    as
    begin
        if id_hospital_timetable is not null and not LEBEDEV_EG.TIME_TABLE_PACKAGE.HOSPITAL_TIMETABLE_IS_EXIST_AS_FUNC(id_hospital_timetable) then
            raise LEBEDEV_EG.EXCEPTIONS.HOSPITAL_TIME_TABLE_NOT_EXIST;
        end if;
        if id_hospital is not null and not LEBEDEV_EG.HOSPITAL_PAKET.HOSPITAL_IS_EXIST_AS_FUNC(id_hospital) then
            raise LEBEDEV_EG.EXCEPTIONS.HOSPITAL_NOT_EXISTS;
        end if;
        if id_day is not null and not LEBEDEV_EG.TIME_TABLE_PACKAGE.DAY_IS_EXIST_AS_FUNC(id_day) then
            raise LEBEDEV_EG.EXCEPTIONS.DAY_OF_WEAK_NOT_EXIST;
        end if;

        SELF.ID_HOSPITAL_TIMETABLE := id_hospital_timetable;
        SELF.ID_HOSPITAL := id_hospital;
        self.ID_DAY := id_day;
        self.START_WORK_TIME := start_work_time;
        self.FINISH_WORK_TIME := finish_work_time;

        return ;
    end;
end;

-- конструктор для талонов
alter type LEBEDEV_EG.T_TALON
add constructor function t_talon (
    id_talon number,
    id_doctor number,
    time_space_from date,
    time_space_to date,
    is_open number
)
return self as result
cascade;

create or replace type body LEBEDEV_EG.T_TALON
as
    constructor function t_talon (
        id_talon number,
        id_doctor number,
        time_space_from date,
        time_space_to date,
        is_open number
    )
    return self as result
    as
    begin
        if id_talon is not null and not LEBEDEV_EG.TIME_TABLE_PACKAGE.TALON_DOCTOR_IS_EXIST_AS_FUNC(id_talon) then
            raise LEBEDEV_EG.EXCEPTIONS.TALON_DOCTOR_NOT_EXIST;
        end if;
        if id_doctor is not null and not LEBEDEV_EG.DOCTOR_PACKAGE.DOCTOR_IS_EXIST_AS_FUNC(id_doctor) then
            raise LEBEDEV_EG.EXCEPTIONS.DOCTOR_NOT_EXISTS;
        end if;

        SELF.ID_TALON := id_talon;
        SELF.ID_DOCTOR := id_doctor;
        SELF.TIME_SPACE_FROM := time_space_from;
        self.TIME_SPACE_TO := time_space_to;
        SELF.IS_OPEN := is_open;

        return ;
    end;
end;

-- конструктор для журнала
alter type LEBEDEV_EG.T_JOURNAL
add constructor function t_journal (
    id_patient number,
    id_talon number,
    available number,
    rating number
)
return self as result
cascade;

create or replace type body LEBEDEV_EG.T_JOURNAL
as
    constructor function t_journal (
        id_patient number,
        id_talon number,
        available number,
        rating number
    )
    return self as result
    as
    begin
        if id_patient is not null and not LEBEDEV_EG.PATIENT_PACKAGE.PATIENT_EXISTS_AS_FUNC(id_patient) then
            raise LEBEDEV_EG.EXCEPTIONS.PATIENT_NOT_EXISTS;
        end if;
        if id_talon is not null and not LEBEDEV_EG.TIME_TABLE_PACKAGE.TALON_DOCTOR_IS_EXIST_AS_FUNC(id_talon) then
            raise LEBEDEV_EG.EXCEPTIONS.TALON_DOCTOR_NOT_EXIST;
        end if;

        self.ID_PATIENT := id_patient;
        SELF.ID_TALON := id_talon;
        SELF.AVAILABLE := available;
        SELF.RATING := rating;

        return ;
    end;
end;

-- конструктор для расширенного пациента:
alter type LEBEDEV_EG.T_EXTENDED_PATIENT
add constructor function t_extended_patient (
    patient LEBEDEV_EG.t_patient,
    documents LEBEDEV_EG.t_patient_document
)
return self as result
cascade;

create or replace type body LEBEDEV_EG.T_EXTENDED_PATIENT
as
    constructor function t_extended_patient (
        patient LEBEDEV_EG.t_patient,
        documents LEBEDEV_EG.t_patient_document
    )
    return self as result
    as
    begin
        self.PATIENT := patient;
        SELF.DOCUMENTS := documents;

        return ;
    end;
end;

-- конструктор для расширенной больницы
alter type LEBEDEV_EG.T_EXTENDED_HOSPITAL
add constructor function T_EXTENDED_HOSPITAL (
    hospital LEBEDEV_EG.t_hospital,
    hospital_timetable LEBEDEV_EG.t_hospital_time_table
)
return self as result
cascade;

create or replace type body LEBEDEV_EG.T_EXTENDED_HOSPITAL
as
    constructor function T_EXTENDED_HOSPITAL (
        hospital LEBEDEV_EG.t_hospital,
        hospital_timetable LEBEDEV_EG.t_hospital_time_table
    )
    return self as result
    as
    begin
        SELF.HOSPITAL := hospital;
        self.HOSPITAL_TIMETABLE := hospital_timetable;

        return ;
    end;
end;

-- создание getter'ов будет в пакетах:

-- пример работы getter'а для специальности:
declare
    v_speciality lebedev_eg.T_SPECIALITY;
begin
    v_speciality := lebedev_eg.SPECIALITY_PACKAGE.GET_SPECIALITY_TAPE_AS_FUNC(15);
    DBMS_OUTPUT.PUT_LINE(v_speciality.NAME_SPECIALITY || v_speciality.ID_SPECIALITY);
end;

declare
    v_patient lebedev_eg.T_PATIENT;
begin
    v_patient := lebedev_eg.PATIENT_PACKAGE.GET_PATIENT_TYPE_AS_FUNC(8000);
    DBMS_OUTPUT.PUT_LINE(v_patient.NAME || v_patient.ID_PATIENT);
end;


declare
    v_patient_document lebedev_eg.T_ARR_PATIENT_DOCUMENTS;
begin
    v_patient_document := lebedev_eg.DOCUMENT_PACKAGE.GET_PATIENT_DOCUMENT_AS_FUNC(8000);
    for i in v_patient_document.FIRST..v_patient_document.COUNT
    loop
        DBMS_OUTPUT.PUT_LINE(v_patient_document(i).ID_DOCUMENT|| v_patient_document(i).ID_PATIENT || v_patient_document(i).VALUE);
    end loop;
end;


declare
    v_doctor lebedev_eg.T_DOCTOR;
begin
    v_doctor := lebedev_eg.DOCTOR_PACKAGE.GET_DOCTOR_TYPE_AS_FUNC(900);
    DBMS_OUTPUT.PUT_LINE(v_doctor.ID_DOCTOR || v_doctor.QUALIFICATION);

    EXCEPTION when others then
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
end;

declare
    v_hospital lebedev_eg.T_HOSPITAL;
begin
    v_hospital := lebedev_eg.HOSPITAL_PAKET.GET_HOSPITAL_TYPE_AS_FUNC(20);
    DBMS_OUTPUT.PUT_LINE(v_hospital.NAME_HOSPITAL || v_hospital.ID_HOSPITAL);
end;

declare
    v_arr_hospital_time_table lebedev_eg.T_ARR_HOSPITAL_TIME_TABLE;
begin
    v_arr_hospital_time_table := lebedev_eg.TIME_TABLE_PACKAGE.GET_HOSPITAL_TIME_TABLE_TYPE_AS_FUNC(20);
    for i in v_arr_hospital_time_table.first .. v_arr_hospital_time_table.COUNT
    loop
        DBMS_OUTPUT.PUT_LINE(v_arr_hospital_time_table(i).id_hospital_timetable || v_arr_hospital_time_table(i).id_hospital);
    end loop;
end;

declare
    v_hospital lebedev_eg.T_TALON;
begin
    v_hospital := lebedev_eg.HOSPITAL_PAKET.GET_HOSPITAL_TYPE_AS_FUNC(20);
    DBMS_OUTPUT.PUT_LINE(v_hospital.NAME_HOSPITAL || v_hospital.ID_HOSPITAL);
end;


declare
    v_arr_journal lebedev_eg.T_ARR_JOURNAL;
begin
    v_arr_journal := lebedev_eg.TIME_TABLE_PACKAGE.GET_JOURNAL_TYPE_AS_FUNC(10000);
    for i in v_arr_journal.first .. v_arr_journal.LAST
    loop
        DBMS_OUTPUT.PUT_LINE(v_arr_journal(i).id_patient || v_arr_journal(i).id_talon);
    end loop;
end;




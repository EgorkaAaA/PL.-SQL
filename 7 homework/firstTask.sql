-- создание типов для таблиц

-- специальность:
create or replace type lebedev_eg.t_speciality as object (
    id_speciality number,
    name_speciality varchar(100),
    id_age_group number,
    deleted date
                                                         );


-- пациент:
create or replace type lebedev_eg.t_patient as object (
    id_patient number,
    surname varchar(100),
    name varchar(100),
    patronumic varchar(100),
    id_sex number,
    phone number,
    area number,
    birthday date
                                                      );

-- документы пациента:
create or replace type lebedev_eg.t_patient_document as object (
    id_patient number,
    id_document number,
    value varchar(100)
                                                               );

-- массив документов пациента
create or replace type lebedev_eg.t_arr_patient_documents as table of lebedev_eg.t_patient_document;

-- доктор:
create or replace type lebedev_eg.t_doctor as object (
    id_doctor number,
    id_hospital number,
    area number,
    qualification varchar(100),
    deleted date
                                                     );

-- больница:
create or replace type lebedev_eg.t_hospital as object (
    id_hospital number,
    name_hospital varchar(100),
    is_open number,
    id_medical_organization number,
    id_hospital_tape number,
    deleted date
                                                       );

-- расписание больницы:
create or replace type lebedev_eg.t_hospital_time_table as object (
    id_hospital_timetable number,
    id_hospital number,
    id_day number,
    start_work_time date,
    finish_work_time date
                                                                  );

-- массив расписания таблиц
create or replace type LEBEDEV_EG.t_arr_hospital_time_table as table of LEBEDEV_EG.T_HOSPITAL_TIME_TABLE;

-- талон:
create or replace type lebedev_eg.t_talon as object (
    id_talon number,
    id_doctor number,
    time_space_from date,
    time_space_to date,
    is_open number
                                                    );

-- масив талонов:
create or replace type LEBEDEV_EG.t_arr_talon as table of LEBEDEV_EG.T_TALON;

-- журнал
create or replace type lebedev_eg.t_journal as object (
    id_patient number,
    id_talon number,
    available number,
    rating number
                                                      );

-- массив с журналами
create or replace type LEBEDEV_EG.t_arr_journal as table of LEBEDEV_EG.t_journal;
-- создание расширенных типов

-- расширенный пациент:
create or replace type lebedev_eg.t_extended_patient as object (
    patient lebedev_eg.t_patient,
    documents lebedev_eg.t_patient_document
                                                               );

-- расширенная больница:
create or replace type lebedev_eg.t_extended_hospital as object (
    hospital lebedev_eg.t_hospital,
    hospital_timetable lebedev_eg.t_hospital_time_table
                                                            );


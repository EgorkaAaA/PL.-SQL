-- создание пакета с логикой пацинтов

-- голова пакета:
create or replace package lebedev_eg.patient_package
as
    -- функция возвращающая возраст определенного пациента
    function select_patient_age_as_func (
        p_id_patient number
    )
    return number;

    -- функция проверяющая записывался ли пациент на этот талон
    function patient_not_registered_on_talon_as_func (
        p_id_patient number,
        p_id_talon number
    )
    return boolean;

    -- функция проверяющая подходит ли возраст этого пациента под возрастную группу специальности
    function patient_age_is_ok_as_func (
        p_id_patient number,
        p_id_talon number
    )
    return boolean;

    -- фунция проверяющая подходит ли пол пациента под пол специальности
    function patient_sex_equals_speciality_sex_as_func (
        p_id_patient number,
        p_id_talon number
    )
    return boolean;

    -- функция возвращающая id омс
    function id_oms
    return number;

    -- функция проверяющая есть ли у пациента омс
    function patient_have_oms_as_func (
        p_id_patient number
    )
    return boolean;

    function patient_exists_as_func (
        p_id_patient number
    )
    return boolean;

    function get_patient_type_as_func (
        p_id_patient number
    )
    return lebedev_eg.t_patient;
end;

-- тело пакета:
create or replace package body lebedev_eg.patient_package
as
    function select_patient_age_as_func (
        p_id_patient number
    )
    return number
    as
        v_age number;
    begin
        select months_between(sysdate, p.birthday) / 12
           into v_age
        from lebedev_eg.patient p
        where p.id_patient = p_id_patient;

        return v_age;
    end;

    function patient_not_registered_on_talon_as_func (
        p_id_patient number,
        p_id_talon number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
            into v_row_count
        from lebedev_eg.journal j
        where j.id_patient = p_id_patient
            and
            j.id_talon = p_id_talon;

        return v_row_count > 0;
    end;

    function patient_age_is_ok_as_func (
        p_id_patient number,
        p_id_talon number
    )
    return boolean
    as
        v_patient_age number;
        v_row_count number;
    begin
        v_patient_age := lebedev_eg.patient_package.select_patient_age_as_func(p_id_patient);

    select count(*)
        into v_row_count
    from lebedev_eg.doctor_timetable dt

    inner join lebedev_eg.doctor d
        on dt.id_doctor = d.id_doctor
    inner join lebedev_eg.doctor_speciality ds
        on d.id_doctor = ds.id_doctor
    inner join lebedev_eg.speciality s
        on ds.id_speciality = s.id_speciality
    inner join lebedev_eg.age_group ag
        on s.id_age_group = ag.id_age_group

    where (
        ag.min_age < v_patient_age
            and
        ag.max_age > v_patient_age
            and
        dt.id_timetable = p_id_talon);

    return v_row_count > 0;
    end;

    function patient_sex_equals_speciality_sex_as_func (
        p_id_patient number,
        p_id_talon number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
            into v_row_count
        from lebedev_eg.doctor_timetable dt

        inner join lebedev_eg.doctor d
            on dt.id_doctor = d.id_doctor
        inner join lebedev_eg.doctor_speciality ds
            on d.id_doctor = ds.id_doctor
        inner join lebedev_eg.speciality s
            on ds.id_speciality = s.id_speciality
        inner join lebedev_eg.speciality_sex ss
            on s.id_speciality = ss.id_speciality

        where (
                dt.id_timetable = p_id_talon
                    and
                ss.id_sex = (select p.id_sex
                            from lebedev_eg.patient p
                             where p.id_patient = p_id_patient)
                  );

        return v_row_count > 0;
    end;

    function id_oms
    return number
    as
        v_id_oms number;
    begin
        select d.id_document
            into v_id_oms
        from lebedev_eg.document d
        where upper(d.name) = upper('омс');

        return v_id_oms;
    end;

    function patient_have_oms_as_func (
        p_id_patient number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
            into v_row_count
        from lebedev_eg.patient p
        inner join lebedev_eg.patient_document pd
            on p.id_patient = pd.id_patient
        where p.id_patient = p_id_patient
                and
              pd.id_document = lebedev_eg.patient_package.id_oms;

        return v_row_count > 0;
    end;

    function patient_exists_as_func (
        p_id_patient number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.patient
        where id_patient = p_id_patient;

        return v_row_count > 0;
    end;

    function get_patient_type_as_func (
        p_id_patient number
    )
    return lebedev_eg.t_patient
    as
        v_patient lebedev_eg.t_patient;
    begin
        select lebedev_eg.t_patient(id_patient => p.id_patient,
                                surname => p.surname,
                                name => p.name,
                                patronumic => p.patronymic,
                                id_sex => p.id_sex,
                                phone => p.phone,
                                area => p.area,
                                birthday => p.birthday)
        into v_patient
        from lebedev_eg.patient p
        where p.id_patient = p_id_patient;

        return v_patient;
    end;
end;


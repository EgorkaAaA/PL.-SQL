-- задание 2:

-- Функция возвращающая возраст пациента
create or replace function lebedev_eg.select_patient_age(
    p_id_patient number
)
return number
as
    v_birthday number;
begin
    select months_between(sysdate, p.birthday) / 12
           into v_birthday
    from lebedev_eg.patient p
    where p.id_patient = p_id_patient;

    return v_birthday;
end;

-- проверка на то записан пациент на талон или нет
create or replace function lebedev_eg.patient_not_registered_on_talon (
    p_id_patient number,
    p_id_talon number
)
return varchar
as
    v_row_count number;
begin
    select count(*)
        into v_row_count
    from lebedev_eg.journal j
    where j.id_patient = p_id_patient
        and
        j.id_talon = p_id_talon;

    if v_row_count = 0
        then
            return null;
        else
            return 'пациент записан на талон' || chr(10);
    end if;
end;


-- получить специальность по номеру талона
create or replace function lebedev_eg.get_speciality_by_talon_id (
    v_id_talon number
)
return lebedev_eg.speciality%rowtype
as
    v_speciality lebedev_eg.speciality%rowtype;
begin
    select s.*
        into v_speciality
    from lebedev_eg.speciality s
    inner join lebedev_eg.doctor_speciality ds
        on s.id_speciality = ds.id_speciality
    inner join lebedev_eg.doctor d
        on ds.id_doctor = d.id_doctor
    inner join doctor_timetable dt
        on d.id_doctor = dt.id_doctor
            and
           dt.id_timetable = v_id_talon;

    return v_speciality;
end;


-- совпадение возраста пациента с возрастным диопазоном специальности
create or replace function lebedev_eg.patient_age_is_ok (
    p_id_patient number,
    p_id_talon number
)
return varchar
as
    v_row_count number;
    v_patient_age number;
begin
    v_patient_age := lebedev_eg.select_patient_age(p_id_patient);

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

    if v_row_count > 0
        then
            return null;
        else
            return 'возраст пациента не подходит по возрастную группу специальности' || chr(10);
    end if;
end;


-- совпадение пола пациента и пола специальности
create or replace function lebedev_eg.patient_sex_equals_speciality_sex (
    p_id_patient number,
    p_id_talon number
)
return varchar
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

    if v_row_count > 0
        then
            return null;
        else
            return 'пол пациента не совпадает с полом специальности' || chr(10);
    end if;
end;


-- открыт ли талон на который происходит запись
create or replace function lebedev_eg.talon_is_open_as_func  (
    p_id_talon number
)
return varchar
as
    v_is_open number;
begin
    select count(*)
        into v_is_open
    from lebedev_eg.doctor_timetable dt
    where dt.id_timetable = p_id_talon
            and
          dt.is_open = 1;

    if v_is_open > 0
        then
            return null;
        else
            return 'талон закрыт' || chr(10);
    end if;
end;

-- проверка на то что время начала талона больше текущего времени
create or replace function lebedev_eg.talon_date_more_then_now_as_func (
    p_id_talon number
)
return varchar
as
    v_talon_is_available number;
begin
    select count(*)
        into v_talon_is_available
        from lebedev_eg.doctor_timetable dt
        where dt.id_timetable = p_id_talon
                and
              dt.time_spaces_from > sysdate;

    if v_talon_is_available > 0
        then
            return null;
        else
            return 'время начала талона меньше нынешней даты' || chr(10);
    end if;
end;

-- проверка на удаленность доктора
create or replace function lebedev_eg.doctor_is_deleted_as_func (
    p_id_talon number
)
return varchar
as
    v_doctor_is_available number;
begin
    select count(*)
        into v_doctor_is_available
    from lebedev_eg.doctor_timetable dt
    inner join doctor d
        on d.id_doctor = dt.id_doctor
    where dt.id_timetable = p_id_talon
            and
          d.deleted is null;

    if v_doctor_is_available > 0
        then
            return  null;
        else
            return 'доктор удален' || chr(10);
    end if;
end;

-- проверка на не удаленность больницы по талону
create or replace function lebedev_eg.hospital_is_deleted_as_func (
    p_id_talon number
)
return varchar
as
    v_hospital_is_available number;
begin
    select count(*)
        into v_hospital_is_available
    from lebedev_eg.doctor_timetable dt
    inner join doctor d
        on d.id_doctor = dt.id_doctor
    inner join lebedev_eg.hospital h
        on d.id_hospital = h.id_hospital
    where dt.id_timetable = p_id_talon
            and
          h.deleted is null;

    if
        v_hospital_is_available > 0
        then
            return null;
        else
            return 'больница удалена' || chr(10);
    end if;
end;

-- проверка не удаленности специальности по талону
create or replace function lebedev_eg.speciality_is_deleted_as_func (
    p_id_talon number
)
return varchar
as
    v_speciality lebedev_eg.speciality%rowtype;
begin
    v_speciality := lebedev_eg.get_speciality_by_talon_id(p_id_talon);

    if v_speciality.deleted is null
        then
            return null;
        else
            return 'специальность удалена' || chr(10);
    end if;
end;

-- функция возвращающая id омс
create or replace function lebedev_eg.id_oms
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

-- наличие у пациента омс
create or replace function lebedev_eg.patient_have_oms_as_func (
    p_id_patient number
)
return varchar
as
    v_patient_have_oms number;
begin
    select count(*)
        into v_patient_have_oms
    from lebedev_eg.patient p
    inner join lebedev_eg.patient_document pd
        on p.id_patient = pd.id_patient
    where p.id_patient = p_id_patient
            and
          pd.id_document = lebedev_eg.id_oms;

    if v_patient_have_oms > 0
        then
            return null;
        else
            return 'пациент не имеет омс' || chr(10);
    end if;
end;


/*
    функция составление сообщения об ошибке
    в слуаче если все парвильно вернется null
    в ином случае будет составлено сообщение с ошибками, которые были совершены при записи
 */
 create or replace function lebedev_eg.checking_all_conditions_for_registration_on_talon_as_func (
    p_id_patient number,
    p_id_talon number
)
return varchar
as
    v_error_message varchar(300) := null;
begin
    if lebedev_eg.patient_not_registered_on_talon(
        p_id_patient => p_id_patient,
        p_id_talon => p_id_talon) is not null then
        raise lebedev_eg.EXCEPTIONS.PATIENT_ALREADY_REG;
    end if;
    if lebedev_eg.patient_sex_equals_speciality_sex(
        p_id_patient => p_id_patient,
        p_id_talon => p_id_talon) is not null then
        raise lebedev_eg.EXCEPTIONS.PATIENT_SEX_NOT_EQUALS_SPECIALITY_SEX;
    end if;
    v_error_message := lebedev_eg.patient_age_is_ok(
        p_id_patient => p_id_patient,
        p_id_talon => p_id_talon)
    || lebedev_eg.talon_is_open_as_func(
        p_id_talon => p_id_talon)
    || lebedev_eg.talon_date_more_then_now_as_func(
        p_id_talon => p_id_talon)
    || lebedev_eg.doctor_is_deleted_as_func(
        p_id_talon => p_id_talon)
    || lebedev_eg.hospital_is_deleted_as_func(
        p_id_talon => p_id_talon)
    || lebedev_eg.speciality_is_deleted_as_func(
        p_id_talon => p_id_talon)
    || lebedev_eg.patient_have_oms_as_func(
        p_id_patient => p_id_patient);

    return v_error_message;
end;

-- функция записи на талон
create or replace function lebedev_eg.add_talon_in_patient_journal_as_func (
    p_id_patient number,
    p_id_talon number
)
return varchar
as
    v_message varchar(100);
begin
    insert into lebedev_eg.journal (id_patient, id_talon, available)
        values (p_id_patient, p_id_talon, 1);
    commit;

    update lebedev_eg.doctor_timetable dt set dt.is_open = 0 where dt.id_timetable = p_id_talon;
    commit;

    v_message := 'пользовтель успешно записался к врачу';
    return v_message;
end;


-- процедура записи пациаента на прием к врачу
create or replace procedure lebedev_eg.registration_on_talon_as_proc (
    p_id_patient in number,
    p_id_talon in number
)
as
    v_message varchar(300);
begin
    v_message := lebedev_eg.checking_all_conditions_for_registration_on_talon_as_func(
        p_id_patient => p_id_patient,
        p_id_talon => p_id_talon);

    if v_message is null
        then
            dbms_output.put_line(lebedev_eg.add_talon_in_patient_journal_as_func(
                p_id_patient => p_id_patient,
                p_id_talon => p_id_talon));
        else
            dbms_output.put_line(v_message);
    end if;

    EXCEPTION
        when LEBEDEV_EG.EXCEPTIONS.patient_already_reg then
            LEBEDEV_EG.LOGS_PACKAGE.ADD_DEFAULT_LOG(P_OBJECT =>  $$plsql_unit_owner||'.'||$$plsql_unit,
                p_value_json =>'Пользоваетль уже зарегистрирован',
                P_SQLERRM => sqlerrm,
                p_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(),
                p_tape => 'error');
        when LEBEDEV_EG.EXCEPTIONS.PATIENT_SEX_NOT_EQUALS_SPECIALITY_SEX then
            LEBEDEV_EG.LOGS_PACKAGE.ADD_DEFAULT_LOG(P_OBJECT =>  $$plsql_unit_owner||'.'||$$plsql_unit,
                p_value_json =>'Пол пациента не совпадает с полом специальности',
                P_SQLERRM => sqlerrm,
                p_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(),
                p_tape => 'error');
        when others then
            LEBEDEV_EG.LOGS_PACKAGE.ADD_DEFAULT_LOG(P_OBJECT =>  $$plsql_unit_owner||'.'||$$plsql_unit,
                p_value_json =>'Ошибки',
                P_SQLERRM => sqlerrm,
                p_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(),
                p_tape => 'error');
end;








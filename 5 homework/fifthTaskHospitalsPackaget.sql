-- создание пакета с логикой для больниц

-- голова пакета:
create or replace package lebedev_eg.hospital_paket
as
    -- функция возвращающая id частной больнице
    function id_private_hospital
    return number;

    -- функция возвращающая id государственной больнице
    function id_public_hospital
    return number;

    -- функция возвращающая значение об удаленности больници по ее id
    function hospital_is_deleted_by_id_as_func(p_id_hospital number)
    return boolean;

    -- функция возвращающая занечение об удаленности больнице по id талона
    function hospital_is_deleted_by_talon_id_as_func(p_id_talon number)
    return boolean;

    -- фунция возвращающая курсор с больницами работающими по данной специальности
    function select_hospital_on_speciality_as_func (
        p_id_speciality number
    )
    return sys_refcursor;

    -- функция возвращающая курсор с расписанием больниц
    function select_hospital_timetable_as_func (
        p_id_hosp number
    )
    return sys_refcursor;

    function hospital_is_exist_as_func (
        p_id_hospital number
    )
    return boolean;

    function medical_organization_is_exist_as_func (
        p_id_medical_org number
    )
    return boolean;

    function hospital_tape_is_exist_as_func (
        p_id_hosp_tape number
    )
    return boolean;

    function get_hospital_type_as_func (
        p_id_hospital number
    )
    return lebedev_eg.t_hospital;

    function repository_get_hospitals (
        out_result out number
    )
    return clob;

    procedure insert_hospital (
        p_hospital_from_antonov lebedev_eg.T_ARR_HOSPITAL_FROM_API_ATONOV
    );
end;


-- создание тела паета
create or replace package body lebedev_eg.hospital_paket
as
    -- функция возвращающая id частной больнице
    function id_private_hospital
    return number
    as
        v_id_private_hospital number;
    begin
        select ht.id_hospital_tape
            into v_id_private_hospital
        from lebedev_eg.hospital_tape ht
        where upper(ht.name_hospital_tape) = upper('частная');

        return v_id_private_hospital;
    end;

    -- функция возвращающая id государственной больнице
    function id_public_hospital
    return number
    as
        v_id_public_hospital number;
    begin
        select ht.id_hospital_tape
            into v_id_public_hospital
        from lebedev_eg.hospital_tape ht
        where upper(ht.name_hospital_tape) = upper('государственная');

        return v_id_public_hospital;
    end;

    function hospital_is_deleted_by_id_as_func(
        p_id_hospital number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
            into v_row_count
        from lebedev_eg.hospital h
        where h.id_hospital = p_id_hospital
            and
              h.deleted is null;

        return v_row_count > 0;
    end;

    function hospital_is_deleted_by_talon_id_as_func(
        p_id_talon number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
            into v_row_count
        from lebedev_eg.doctor_timetable dt
        inner join doctor d
            on d.id_doctor = dt.id_doctor
        inner join lebedev_eg.hospital h
            on d.id_hospital = h.id_hospital
        where dt.id_timetable = p_id_talon
                and
              h.deleted is null;


    return v_row_count > 0;

    end;

    function select_hospital_on_speciality_as_func (
        p_id_speciality number
    )
    return sys_refcursor
    as
        v_cursor_1 sys_refcursor;
    begin
        open v_cursor_1 for
        select count(d.id_doctor) as count, h.name_hospital, ds.id_speciality,h.is_open  from hospital h
        inner join lebedev_eg.doctor d
        on h.id_hospital = d.id_hospital
        inner join lebedev_eg.doctor_speciality ds
        on ds.id_doctor = d.id_doctor
        where ((p_id_speciality is null) or (ds.id_speciality = p_id_speciality)) and (h.deleted is null and d.deleted is null)
        group by h.id_hospital, h.name_hospital,h.is_open,h.id_hospital_tape, ds.id_speciality
        order by case when h.id_hospital_tape = lebedev_eg.hospital_paket.id_public_hospital
                    then 0
                    else 1
                end desc,
                 count(d.id_doctor) desc,
                h.is_open desc;
    return v_cursor_1;
    end;

    function select_hospital_timetable_as_func (
        p_id_hosp number
    )
    return sys_refcursor
    as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
         select * from lebedev_eg.hospital_timetable ht
            where p_id_hosp is null or  ht.id_hospital = p_id_hosp;

    return v_cursor;
    end;

    function hospital_is_exist_as_func (
        p_id_hospital number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.hospital h
        where h.id_hospital = p_id_hospital;

        return v_row_count > 0;
    end;

    function medical_organization_is_exist_as_func (
        p_id_medical_org number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.medical_organization mo
        where mo.id_medical_organization = p_id_medical_org;

        return v_row_count > 0;
    end;

    function hospital_tape_is_exist_as_func (
        p_id_hosp_tape number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.hospital_tape hp
        where hp.id_hospital_tape = p_id_hosp_tape;

        return v_row_count > 0;
    end;

    function get_hospital_type_as_func (
        p_id_hospital number
    )
    return lebedev_eg.t_hospital
    as
        v_hospital lebedev_eg.t_hospital;
    begin
        select lebedev_eg.t_hospital(id_hospital => h.id_hospital,
            name_hospital => h.name_hospital,
            is_open => h.is_open,
            id_medical_organization => h.id_medical_organization,
            id_hospital_tape => h.id_hospital_tape,
            deleted => h.deleted)
        into v_hospital
        from lebedev_eg.hospital h
        where h.id_hospital = p_id_hospital;

        return v_hospital;
    end;

    function repository_get_hospitals (
        out_result out number
    )
    return clob
    as
        v_success boolean;
        v_code number;
        v_clob clob;

    begin
        v_clob := lebedev_eg.http_fetch(
            p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/hospitals',
            p_debug => true,
            out_success => v_success,
            out_code => v_code
        );

        out_result := case when v_success
            then lebedev_eg.exceptions.c_ok
            else lebedev_eg.exceptions.c_error
        end;

        return v_clob;
    end;

    procedure insert_hospital (
        p_hospital_from_antonov lebedev_eg.T_ARR_HOSPITAL_FROM_API_ATONOV
    )
    as
    begin
        merge into lebedev_eg.HOSPITAL origin
        using (
            select ID_HOSPITAL,
                   ADDRESS,
                   name,
                   id_town
            from table ( p_hospital_from_antonov )
        ) new
         on ( origin.ID_OTHER_API = new.ID_HOSPITAL)
        when matched then
            update set
                origin.ADDRESS = new.ADDRESS,
                origin.NAME_HOSPITAL = new.NAME,
                origin.id_town_from_api = new.id_town
        when not matched then
            insert (
                    NAME_HOSPITAL,
                    IS_OPEN,
                    ID_MEDICAL_ORGANIZATION,
                    ID_HOSPITAL_TAPE,
                    ID_OTHER_API,
                    ADDRESS,
                    ID_TOWN_FROM_API
            )
            values (
                    new.NAME,
                    1,
                    1,
                    1,
                    new.ID_HOSPITAL,
                    new.ADDRESS,
                    new.id_town
                   );

    end;
end;
-- создание пакета с логикой для докторов

-- голова пакета:
create or replace package lebedev_eg.doctor_package
as
    -- функция возвращает удален доктор или нет по талону
    function doctor_is_deleted_by_talon_id_as_func (p_id_talon number)
    return boolean;

    -- функция возвращает доктор определенной больнице, а также сортирует по участку
    function select_doctors_in_hospital_with_area_sort_as_func (
    p_id_hospital number,
    p_area number)
    return sys_refcursor;

    procedure insert_doctor (
        p_doctor lebedev_eg.t_arr_doctor_from_api_antonov
    );

    -- функция возвращающая курсор, который содержит в себе активные талоны определенного доктора
    function select_talon_on_doctor_active_date_as_func (
        p_id_doctor number
    )
    return sys_refcursor;

    function doctor_is_exist_as_func(
        p_id_doctor number
    )
    return boolean;

    function get_doctor_type_as_func (
        p_id_doctor number
    )
    return lebedev_eg.t_doctor;

    function repository_get_doctors (
        out_result out number
    )
    return clob;
end;

-- тело пакета:
create or replace package body lebedev_eg.doctor_package
as
    function doctor_is_deleted_by_talon_id_as_func (
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
        where dt.id_timetable = p_id_talon
                and
              d.deleted is null;

        return v_row_count > 0;
    end;

    function select_doctors_in_hospital_with_area_sort_as_func (
        p_id_hospital number,
        p_area number
    )
    return sys_refcursor
    as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
        select * from doctor d
        where (d.id_hospital = p_id_hospital or p_id_hospital is null) and d.deleted is null
        order by d.qualification,
                case when d.area = p_area then 1
                     else 0
                end;

        return v_cursor;
    end;

    function select_talon_on_doctor_active_date_as_func (
        p_id_doctor number
    )
    return sys_refcursor
    as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
        select * from lebedev_eg.doctor_timetable dt
         where
              (p_id_doctor is null or dt.id_doctor = p_id_doctor)
          and
              (dt.time_spaces_to < sysdate and dt.time_spaces_from < sysdate);

    return v_cursor;
    end;

    function doctor_is_exist_as_func(
        p_id_doctor number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.doctor d
        where d.id_doctor = p_id_doctor;

        return v_row_count > 0;
    end;

    function get_doctor_type_as_func (
        p_id_doctor number
    )
    return lebedev_eg.t_doctor
    as
        v_doctor lebedev_eg.t_doctor;
    begin
        select lebedev_eg.t_doctor(id_doctor => d.id_doctor,
                                id_hospital => d.id_hospital,
                                area => d.area,
                                qualification => d.qualification,
                                deleted => d.deleted)
        into v_doctor
        from lebedev_eg.doctor d
        where d.id_doctor = p_id_doctor;

        return v_doctor;
    end;

    function repository_get_doctors(
        out_result out number
    )
    return clob
    as
        v_success boolean;
        v_code number;
        v_clob clob;

    begin
        v_clob := lebedev_eg.http_fetch(
            p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/doctors',
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

    procedure insert_doctor (
        p_doctor lebedev_eg.t_arr_doctor_from_api_antonov
    )
    as
    begin
        merge into lebedev_eg.doctor d
        using (
            select
                id_doctor,
                lname,
                fname,
                mname,
                id_hospital
                from table ( p_doctor )
        ) pd
            on (d.id_from_other_api = pd.id_doctor)
        when matched then
            update set
            d.secondname = pd.lname,
            d.firstname = pd.fname,
            d.surname = pd.mname,
            d.id_hospital = pd.id_hospital
        when not matched then
            insert (id_hospital,
                    area,
                    qualification,
                    surname,
                    firstname,
                    secondname,
                    id_from_other_api)
            values (pd.id_hospital,
                    1,
                    '1',
                    pd.fname,
                    pd.fname,
                    pd.mname,
                    pd.id_doctor);
    end;
end;
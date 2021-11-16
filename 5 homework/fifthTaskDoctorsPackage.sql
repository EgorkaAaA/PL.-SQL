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

    -- функция возвращающая курсор, который содержит в себе активные талоны определенного доктора
    function select_talon_on_doctor_active_date_as_func (
        p_id_doctor number
    )
    return sys_refcursor;
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
end;
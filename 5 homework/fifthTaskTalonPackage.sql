-- создание пакета с логикой для талонов

-- голова пакета:
create or replace package lebedev_eg.talon_package
as
    function talon_is_open_as_func  (
        p_id_talon number
    )
    return boolean;

    function talon_date_more_then_now_as_func (
        p_id_doctor number
    )
    return sys_refcursor;
end;

-- тело пакета:
create or replace package body lebedev_eg.talon_package
as
    function talon_is_open_as_func (
        p_id_talon number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.doctor_timetable dt
        where dt.id_timetable = p_id_talon
                and
              dt.is_open = 1;

        return v_row_count > 0;
    end;

    function talon_date_more_then_now_as_func (
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
            (dt.time_spaces_to > sysdate and dt.time_spaces_from > sysdate);

        return v_cursor;
    end;
end;
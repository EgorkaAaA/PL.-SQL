create or replace package lebedev_eg.time_table_package
as
    function hospital_timetable_is_exist_as_func(
        p_id_hospital_time_table number
    )
    return boolean;

    function day_is_exist_as_func (
        p_id_day number
    )
    return boolean;

    function talon_doctor_is_exist_as_func(
        p_id_talon number
    )
    return boolean;

    function get_hospital_time_table_type_as_func (
        p_id_hospital number
    )
    return lebedev_eg.t_arr_hospital_time_table;

    function get_doctor_talon_type_as_func (
        p_id_doctor number
    )
    return lebedev_eg.t_arr_talon;

    function get_journal_type_as_func (
        p_id_patient number
    )
    return lebedev_eg.t_arr_journal;
end;

create or replace package body lebedev_eg.time_table_package
as
    function hospital_timetable_is_exist_as_func(
        p_id_hospital_time_table number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.hospital_timetable htt
        where htt.id_hospital_timetable = p_id_hospital_time_table;

        return v_row_count > 0;
    end;

    function day_is_exist_as_func (
        p_id_day number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.day_of_week dow
        where dow.id_day = p_id_day;

        return v_row_count > 0;
    end;

    function talon_doctor_is_exist_as_func(
        p_id_talon number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.doctor_timetable dt
        where dt.id_timetable = p_id_talon;

        return v_row_count > 0;
    end;

    function get_hospital_time_table_type_as_func (
        p_id_hospital number
    )
    return lebedev_eg.t_arr_hospital_time_table
    as
        v_hospital_time_table lebedev_eg.t_arr_hospital_time_table;
    begin
        select lebedev_eg.t_hospital_time_table(id_hospital => htt.id_hospital,
                                            id_hospital_timetable => htt.id_hospital_timetable,
                                            start_work_time => htt.start_work_time,
                                            finish_work_time => htt.finish_work_time,
                                            id_day => htt.id_day)
        bulk collect into v_hospital_time_table
        from lebedev_eg.hospital_timetable htt
        where htt.id_hospital = p_id_hospital;

        return v_hospital_time_table;
    end;

    function get_doctor_talon_type_as_func (
        p_id_doctor number
    )
    return lebedev_eg.t_arr_talon
    as
        v_arr_talon lebedev_eg.t_arr_talon;
    begin
        select lebedev_eg.t_talon(id_talon => dtt.id_timetable,
            id_doctor => dtt.id_doctor,
            is_open => dtt.is_open,
            time_space_from => dtt.time_spaces_from,
            time_space_to => dtt.time_spaces_to)
        bulk collect into v_arr_talon
        from lebedev_eg.doctor_timetable dtt
        where dtt.id_doctor = p_id_doctor;

        return v_arr_talon;
    end;

    function get_journal_type_as_func (
        p_id_patient number
    )
    return lebedev_eg.t_arr_journal
    as
        v_arr_journal lebedev_eg.t_arr_journal;
    begin
        select lebedev_eg.t_journal(id_patient => j.ID_PATIENT,
                                id_talon => j.ID_TALON,
                                available => j.AVAILABLE,
                                rating => j.rating)
        bulk collect into v_arr_journal
        from lebedev_eg.journal j
        where j.id_patient = p_id_patient;

        return v_arr_journal;
    end;
end;
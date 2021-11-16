--задание 3:
create or replace procedure lebedev_eg.cancel_registration_on_talon_as_proc (
    v_id_patient in number,
    v_id_talon in number
)
as
    v_cursor_for_select_talon sys_refcursor;
    v_id_talon_from_cursor number;
begin
    open v_cursor_for_select_talon for
        select dt.id_timetable from doctor_timetable dt
        inner join lebedev_eg.doctor d
            on d.id_doctor = dt.id_doctor
        inner join hospital h
            on h.id_hospital = d.id_hospital
        inner join hospital_timetable ht
            on h.id_hospital = ht.id_hospital
        where dt.id_timetable = v_id_talon
          and dt.time_spaces_from < sysdate
          and dt.is_open = 0
          and to_date(to_char(sysdate - interval '2' hour, 'hh24:mi'), 'hh24:mi') < to_date(to_char(finish_work_time,'hh24:mi'),'hh24:mi');

    fetch v_cursor_for_select_talon into v_id_talon_from_cursor;

    close v_cursor_for_select_talon;
    if v_id_talon_from_cursor is not null then
            update journal set available = 0 where id_patient = v_id_patient and id_talon = v_id_talon_from_cursor;
            update doctor_timetable set is_open = 1 where id_timetable = v_id_talon_from_cursor;
            dbms_output.put_line('запись успешно отменена');
        else
            dbms_output.put_line('не то');
    end if;
end;
-- создание пакета с логикой специальностей

-- голова пакета
create or replace package lebedev_eg.speciality_package
as
    -- получение специальности по талону
    function get_speciality_by_talon_id_as_func (
        p_id_talon number
    )
    return lebedev_eg.speciality%rowtype;

    -- функция возвращает курсор, который выбирает неудаленную специальность специальность с неудаленным доктором
    function select_active_speciality_as_func (
        p_id_speciality number
    )
    return sys_refcursor;

    -- функция возвращает удалена специальность или нет по талону
    function speciality_is_deleted_by_talon_id_as_func (
        p_id_talon number
    )
    return boolean;
end;

create or replace package body lebedev_eg.speciality_package
as
    function get_speciality_by_talon_id_as_func (
        p_id_talon number
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
           dt.id_timetable = p_id_talon;

    return v_speciality;
    end;

    function select_active_speciality_as_func (
        p_id_speciality number
    )
    return sys_refcursor
    as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
        select distinct s.* from lebedev_eg.speciality s
        inner join lebedev_eg.doctor_speciality ds
        on s.id_speciality = ds.id_speciality
        inner join doctor d
        on ds.id_doctor = d.id_doctor
        inner join lebedev_eg.hospital h
        on h.id_hospital = d.id_hospital
        where ((p_id_speciality is null)
            or (p_id_speciality = s.id_speciality))
               and (s.deleted is null and d.deleted is null and h.deleted is null);
    return v_cursor;
    end;

    function speciality_is_deleted_by_talon_id_as_func (
        p_id_talon number
    )
    return boolean
    as
        v_speciality lebedev_eg.speciality%rowtype;
    begin
        v_speciality := lebedev_eg.speciality_package.get_speciality_by_talon_id_as_func(p_id_talon);

        return v_speciality.deleted is null;
    end;
end;




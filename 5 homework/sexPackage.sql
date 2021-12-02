create or replace package LEBEDEV_EG.sex_package
as
    function sex_exists_as_func (
        p_id_sex number
    )
    return boolean;
end;

create or replace package body LEBEDEV_EG.sex_package
as
    function sex_exists_as_func (
        p_id_sex number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from LEBEDEV_EG.SEX s
        where s.ID_SEX = p_id_sex;

        return v_row_count > 0;
    end;
end;
create or replace package lebedev_eg.test_doctor
as
    --%suite

     --%beforeall
--     procedure seed_before_all;

    --%test(тест на foreign_key id_hospital)
    --%throws(-01400)
    procedure check_doctor_id_gender_constraint;

    --%test(тест на корректную вставку с ненулевыми значениями)
    procedure check_insert_dcotor;

    --%test(тест на корректный возврат удален ли доктор по талону)
    procedure doctor_not_deleted_by_talon;

    --%test(тест на корректный возврат удален ли доктор)
    procedure doctor_exists;

    --%test(тест на корректный возврат dto доктора)
    procedure get_doctor_dto;

    --%test(тест на корректную работу контролера)
    procedure controller_result;


end;

create or replace package body lebedev_eg.test_doctor
as
    mok_id_hospital number := null;
    mok_id_doctor number := 300;


    procedure check_doctor_id_gender_constraint
    as
    begin
        insert into lebedev_eg.DOCTOR(ID_HOSPITAL)
        values (mok_id_hospital);
    end;

    procedure check_insert_dcotor
    as
        mok_area number := 1;
        mok_qualification varchar2(500) := 'null';
        mok_surname varchar2(500) := 'null';
        mok_firstname varchar2(500) := 'null';
        mok_secondname varchar2(500) := 'null';
        mok_other_id number := 1;
        mok_id_hospital number := 19;
    begin
        insert into lebedev_eg.DOCTOR
                (
                  ID_HOSPITAL,
                  AREA,
                  QUALIFICATION,
                  SURNAME,
                  FIRSTNAME,
                  SECONDNAME,
                  ID_FROM_OTHER_API
                )
        VALUES
               (
                    mok_id_hospital,
                    mok_area,
                    mok_qualification,
                    mok_surname,
                    mok_firstname,
                    mok_secondname,
                    mok_other_id
               );
    end;

    procedure doctor_not_deleted_by_talon
    as
        mok_id_talon number := 300;
        v_result boolean;
    begin
        v_result := lebedev_eg.DOCTOR_PACKAGE.DOCTOR_IS_DELETED_BY_TALON_ID_AS_FUNC(mok_id_talon);

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(true);
    end;

    procedure doctor_exists
    as
        v_result boolean;
    begin
        v_result := lebedev_eg.DOCTOR_PACKAGE.DOCTOR_IS_EXIST_AS_FUNC(mok_id_doctor);

        TOOL_UT3.UT.EXPECT(v_result).TO_EQUAL(true);
    end;

    procedure get_doctor_dto
    as
        v_result lebedev_eg.T_DOCTOR;
        v_doctor lebedev_eg.DOCTOR%rowtype;
    begin
        v_result := lebedev_eg.DOCTOR_PACKAGE.GET_DOCTOR_TYPE_AS_FUNC(mok_id_doctor);

        select * into v_doctor from DOCTOR where ID_DOCTOR = 300;

        TOOL_UT3.UT.EXPECT(v_result.ID_DOCTOR).TO_EQUAL(v_doctor.ID_DOCTOR);
        TOOL_UT3.UT.EXPECT(v_result.ID_HOSPITAL).TO_EQUAL(v_doctor.ID_HOSPITAL);
        TOOL_UT3.UT.EXPECT(v_result.AREA).TO_EQUAL(v_doctor.AREA);
        TOOL_UT3.UT.EXPECT(v_result.QUALIFICATION).TO_EQUAL(v_doctor.QUALIFICATION);
        TOOL_UT3.UT.EXPECT(v_result.DELETED).TO_EQUAL(v_doctor.DELETED);
    end;

    procedure controller_result
    as
        v_result clob;
    begin
        v_result := lebedev_eg.CONTROLLER_GET_DOCTOR_FROM_API_ANTONOV();

        TOOL_UT3.UT.EXPECT(v_result).NOT_TO_BE_NULL();
    end;

end;

begin
    TOOL_UT3.UT.RUN('lebedev_eg.test_doctor');
end;
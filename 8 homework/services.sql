create or replace type lebedev_eg.t_doctor_from_api_antonov as object (
    id_doctor number,
    id_hospital number,
    lname varchar2(500),
    fname varchar2(500),
    mname varchar2(500)

                                                                      );

create or replace type lebedev_eg.t_arr_doctor_from_api_antonov as table of lebedev_eg.t_doctor_from_api_antonov;

create or replace function lebedev_eg.service_get_t_doctor_from_api_antonov(
    out_result out number
)
return lebedev_eg.T_ARR_DOCTOR_FROM_API_ANTONOV
as

    v_result integer;
    v_clob clob;
    v_response lebedev_eg.T_ARR_DOCTOR_FROM_API_ANTONOV := lebedev_eg.T_ARR_DOCTOR_FROM_API_ANTONOV();

begin

    v_clob := lebedev_eg.doctor_package.repository_get_doctors(
        out_result => v_result
    );

    select lebedev_eg.t_doctor_from_api_antonov(
        id_doctor => r.id_doctor,
        id_hospital => r.id_hospital,
        lname => r.lname,
        fname => r.fname,
        mname => r.mname
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_doctor number path '$.id_doctor',
            id_hospital number path '$.id_hospital',
            lname varchar2(100) path '$.lname',
            fname varchar2(100) path '$.fname',
            mname varchar2(100) path '$.mname'
    ))) r;

--     lebedev_eg.DOCTOR_PACKAGE.INSERT_DOCTOR(v_response);
    out_result := lebedev_eg.exceptions.c_ok;


    return v_response;
end;
/

declare

    v_result integer;
    v_response lebedev_eg.t_arr_doctor_from_api_antonov := lebedev_eg.t_arr_doctor_from_api_antonov();

begin

    v_response := lebedev_eg.service_get_t_doctor_from_api_antonov(
        out_result => v_result
    );

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
        declare
            v_item lebedev_eg.t_doctor_from_api_antonov := v_response(i);
        begin
            dbms_output.put_line(v_item.fname);
        end;
    end loop;
    end if;

end;
/

alter table lebedev_eg.hospital
add id_other_api number
add address varchar(500)
add id_town_from_api number;
/

create or replace type lebedev_eg.t_hospital_from_api_antonov as object (
    id_hospital number,
    address varchar(500),
    name varchar(500),
    id_town number
);
/

alter type lebedev_eg.t_hospital_from_api_antonov
add constructor function t_hospital_from_api_antonov(
    p_id_hospital number,
    p_address varchar,
    p_name varchar,
    p_id_town number
)
return self as result;
/

create or replace type body lebedev_eg.t_hospital_from_api_antonov
as
    constructor function t_hospital_from_api_antonov(
        p_id_hospital number,
        p_address varchar,
        p_name varchar,
        p_id_town number
    )
    return self as result
    as
    begin
        self.id_hospital := p_id_hospital;
        self.address := p_address;
        self.name := p_name;
        self.id_town := p_id_town;

        return ;
    end;
end;
/

create or replace type lebedev_eg.t_arr_hospital_from_api_atonov as table of lebedev_eg.t_hospital_from_api_antonov;

create or replace function lebedev_eg.service_get_t_hospital_from_api_antonov(
    out_result out number
)
return lebedev_eg.t_arr_hospital_from_api_atonov
as

    v_result integer;
    v_clob clob;
    v_response lebedev_eg.t_arr_hospital_from_api_atonov := lebedev_eg.t_arr_hospital_from_api_atonov();

begin

    v_clob := lebedev_eg.hospital_paket.repository_get_hospitals(
        out_result => v_result
    );

    select lebedev_eg.t_hospital_from_api_antonov(
        p_id_hospital => r.id_hospital,
        p_address => r.address,
        p_name => r.name,
        p_id_town => r.id_town
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_hospital number path '$.id_hospital',
            address number path '$.address',
            name varchar2(100) path '$.name',
            id_town varchar2(100) path '$.id_town'
    ))) r;


    out_result := v_result;

    return v_response;
end;
/
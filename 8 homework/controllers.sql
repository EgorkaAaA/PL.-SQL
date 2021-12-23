create or replace function lebedev_eg.controller_get_doctor_from_api_antonov
return clob
as

    v_result integer;
    v_response LEBEDEV_EG.T_ARR_DOCTOR_FROM_API_ANTONOV := LEBEDEV_EG.T_ARR_DOCTOR_FROM_API_ANTONOV();
    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_response := LEBEDEV_EG.SERVICE_GET_T_DOCTOR_FROM_API_ANTONOV(
        out_result => v_result
    );

    v_json.put('code', v_result);

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item LEBEDEV_EG.T_DOCTOR_FROM_API_ANTONOV := v_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_doctor', v_item.id_doctor);
        v_object.put('id_hospital', v_item.id_hospital);
        v_object.put('lname', v_item.lname);
        v_object.put('fname', v_item.fname);
        v_object.put('mname', v_item.mname);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;

end;
/

create or replace function lebedev_eg.controller_get_hospital_from_api_antonov
return clob
as

    v_result integer;
    v_response LEBEDEV_EG.T_ARR_HOSPITAL_FROM_API_ATONOV := LEBEDEV_EG.T_ARR_HOSPITAL_FROM_API_ATONOV();
    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_response := LEBEDEV_EG.SERVICE_GET_T_HOSPITAL_FROM_API_ANTONOV(
        out_result => v_result
    );

    v_json.put('code', v_result);

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item LEBEDEV_EG.T_HOSPITAL_FROM_API_ANTONOV := v_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_hospital', v_item.id_hospital);
        v_object.put('address', v_item.address);
        v_object.put('name', v_item.name);
        v_object.put('id_town', v_item.id_town);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response);

    v_return_clob := v_json.to_Clob();

    return v_return_clob;

end;
/


begin
    DBMS_OUTPUT.PUT_LINE(lebedev_eg.controller_get_doctor_from_api_antonov);
end;

begin
    DBMS_OUTPUT.PUT_LINE(lebedev_eg.controller_get_hospital_from_api_antonov);
end;
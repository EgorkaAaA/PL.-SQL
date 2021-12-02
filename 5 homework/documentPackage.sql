create or replace package lebedev_eg.document_package
as
    function document_is_exists_as_func (
        p_id_document number
    )
    return boolean;

    function get_patient_document_as_func (
        p_id_patient number
    )
    return lebedev_eg.t_arr_patient_documents;
end;

create or replace package body lebedev_eg.document_package
as
    function document_is_exists_as_func (
        p_id_document number
    )
    return boolean
    as
        v_row_count number;
    begin
        select count(*)
        into v_row_count
        from lebedev_eg.document d
        where d.id_document = p_id_document;

        return v_row_count > 0;
    end;

    function get_patient_document_as_func (
        p_id_patient number
    )
    return lebedev_eg.t_arr_patient_documents
    as
        v_patient_documents lebedev_eg.t_arr_patient_documents;
    begin
        select lebedev_eg.T_PATIENT_DOCUMENT(id_patient => pd.id_patient,
                                        id_document => pd.id_document,
                                        value => pd.value)
        bulk collect into v_patient_documents
        from lebedev_eg.patient_document pd
        where pd.id_patient = p_id_patient;

        return v_patient_documents;
    end;
end;
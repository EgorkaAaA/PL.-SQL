begin
    sys.dbms_scheduler.create_job(
        job_name        => 'LEBEDEV_EG.SERVICE_GET_T_HOSPITAL_FROM_API_ANTONOV',
        start_date      => sysdate,
        repeat_interval => 'FREQ=SECONDLY;INTERVAL=3;',
        end_date        =>  sysdate + 5,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin student.job_test_action; end;',
        comments        => 'Тестовая задача'
    );

    sys.dbms_scheduler.create_job(
        job_name        => 'LEBEDEV_EG.SERVICE_GET_T_DOCTOR_FROM_API_ANTONOV',
        start_date      => sysdate,
        repeat_interval => 'FREQ=SECONDLY;INTERVAL=3;',
        end_date        =>  sysdate + 5,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin student.job_test_action; end;',
        comments        => 'Тестовая задача'
    );
end;

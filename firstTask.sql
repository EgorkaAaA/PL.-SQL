create table LEBEDEV_EG.REGION (
    id_region number generated by default as identity
        (start with 1 maxvalue 999999 minvalue 1 nocache nocycle noorder) primary key,
    name_region varchar(100)
);
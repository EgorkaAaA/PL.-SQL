create table book (
    id number generated by default as identity (minvalue 1 maxvalue 99999 start with 1 noorder nocache nocycle) primary key,
    name varchar(100) not null
);

create table booking_journal (
    id_patient number references PATIENT(ID_PATIENT) not null,
    id_book number references book(id) not null,
    primary key (id_patient,id_book)
);
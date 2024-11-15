create table User (
    pseudo varchar(15) primary key,
    name varchar(30),
    surname varchar(30),
    mail varchar(30) not null,
    password varchar(30) not null,
    IPaddress varchar(15) not null,
    description varchar(160),
    ban_end date,
    ban_reason varchar(160)
);
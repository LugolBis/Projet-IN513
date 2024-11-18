-- Création de la table
create table Users (
    pseudo varchar(15) primary key,
    name varchar(30),
    surname varchar(30),
    mail varchar(256) not null,
    password varchar(256) not null,
    IPaddress varchar(256) not null,
    description varchar(160),
    ban_end date,
    ban_reason varchar(160)
);
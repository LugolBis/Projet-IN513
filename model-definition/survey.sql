-- Création de la table
create table Survey(
    idsurvey Number(6) primary key,
    question varchar(280) not null,
    idpost number(6),
    foreign key (idpost) references Post(idpost) on delete cascade
);
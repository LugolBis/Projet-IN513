-- Création de la table
create table Options(
    idoption Number(6) primary key,
    content varchar(150) not null,
    idsurvey Number(6),
    foreign key (idsurvey) references Survey(idsurvey) on delete cascade
);
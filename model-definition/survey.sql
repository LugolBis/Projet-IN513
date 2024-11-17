-- Création de la table
create table Survey(
    idsurvey Number(5) primary key,
    question varchar(280) not null,
    idpost Number(5),
    foreign key (idpost) references Post(idpost) on delete cascade
);
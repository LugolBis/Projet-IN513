create table Option(
    idoption Number(6),
    content varchar(150) not null,
    idsurvey Number(5),
    primary key (idoption, idsurvey)
);
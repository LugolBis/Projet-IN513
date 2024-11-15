create table Survey(
    idsurvey Number(5),
    question varchar(280) not null,
    idpost Number(5),
    primary key (idsurvey, idpost)
);
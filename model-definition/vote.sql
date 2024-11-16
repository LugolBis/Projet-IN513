create table Vote(
    pseudo varchar(15),
    idpost Number(5),
    value Number(1) not null,
    primary key (pseudo, idpost)
);
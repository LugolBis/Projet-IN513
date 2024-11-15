create table Vote(
    user varchar(15),
    idpost Number(5),
    value Number(1) not null,
    primary key (user, idpost)
);
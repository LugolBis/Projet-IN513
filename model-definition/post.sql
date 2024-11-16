create table Post (
    idpost Number(5),
    message varchar(280) not null,
    date_post date not null,
    room varchar(20),
    building varchar(20),
    pseudo varchar(15),
    primary key (idpost, pseudo)
);
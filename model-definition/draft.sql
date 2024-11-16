create table Draft(
    iddraft Number(5),
    message varchar(280),
    pseudo varchar(15),
    primary key (iddraft, pseudo)
);
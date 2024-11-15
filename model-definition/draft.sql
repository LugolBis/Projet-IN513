create table Draft(
    iddraft Number(5),
    message varchar(280),
    user varchar(15),
    primary key (iddraft, user)
);
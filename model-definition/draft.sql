-- Création de la table
create table Draft(
    iddraft Number(5) primary key,
    message varchar(280),
    pseudo varchar(15),
    state boolean,
    foreign key (pseudo) references Users(pseudo) on delete cascade
);
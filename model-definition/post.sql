-- Création de la table
create table Post (
    idpost varchar(16) primary key,
    message varchar(280) not null,
    date_post date not null,
    room varchar(20),
    building varchar(20),
    pseudo varchar(15),
    foreign key (pseudo) references Users(pseudo) on delete cascade
);
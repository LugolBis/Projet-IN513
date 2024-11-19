-- Création de la table
create table Vote(
    pseudo varchar(15),
    idpost varchar(16),
    value Number(1) not null,
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idpost) references Post(idpost) on delete cascade
);
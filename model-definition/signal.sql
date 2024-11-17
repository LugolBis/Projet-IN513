-- Création de la table
create table Signal(
    pseudo varchar(15),
    idpost Number(5),
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idpost) references Post(idpost) on delete cascade
);
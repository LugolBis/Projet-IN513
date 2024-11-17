-- Création de la table
create table Answer(
    pseudo varchar(15),
    idoption Number(6),
    primary key (pseudo, idoption),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idoption) references Options(idoption) on delete cascade
);
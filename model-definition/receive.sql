-- Création de la table
create table Receive(
    idpm Number(6),
    pseudo varchar(15),
    primary key (idpm, pseudo),
    foreign key (pseudo) references Users(pseudo) on delete cascade
);
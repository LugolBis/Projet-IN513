-- Création de la table
create table PrivateMessage(
    idpm Number(6) primary key,
    message varchar(280) not null,
    date_send date not null,
    sender varchar(15),
    foreign key (sender) references Users(pseudo) on delete cascade
);
create table PrivateMessage(
    idpm Number(6),
    message varchar(280) not null,
    date_send date not null,
    sender varchar(15),
    primary key (idpm, sender)
);
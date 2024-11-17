-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE PrivateMessage';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table PrivateMessage(
    idpm Number(6),
    message varchar(280) not null,
    date_send date not null,
    sender varchar(15),
    primary key (idpm, sender),
    foreign key (sender) references Users(pseudo)
);
-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Receive';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Receive(
    idpm Number(6),
    pseudo varchar(15),
    primary key (idpm, pseudo)
);
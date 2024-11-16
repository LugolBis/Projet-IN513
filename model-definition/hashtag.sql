-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Hashtag';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Hashtag(
    name varchar(140) primary key
);
-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Signal';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Signal(
    pseudo varchar(15),
    idpost Number(5),
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo),
    foreign key (idpost) references Post(idpost)
);
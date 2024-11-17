-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Answer';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Answer(
    pseudo varchar(15),
    idoption Number(6),
    primary key (pseudo, idoption),
    foreign key (pseudo) references Users(pseudo),
    foreign key (idoption) references Options(idoption)
);
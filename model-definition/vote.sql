-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Vote';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Vote(
    pseudo varchar(15),
    idpost Number(5),
    value Number(1) not null,
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo),
    foreign key (idpost) references Post(idpost)
);
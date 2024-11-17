-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Options';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Options(
    idoption Number(6),
    content varchar(150) not null,
    idsurvey Number(5),
    primary key (idoption, idsurvey),
    foreign key (idsurvey) references Survey(idsurvey)
);
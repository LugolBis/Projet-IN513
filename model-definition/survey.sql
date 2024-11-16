-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Survey';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Survey(
    idsurvey Number(5),
    question varchar(280) not null,
    idpost Number(5),
    primary key (idsurvey, idpost)
);
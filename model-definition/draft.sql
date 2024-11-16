-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Draft';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Draft(
    iddraft Number(5),
    message varchar(280),
    pseudo varchar(15),
    primary key (iddraft, pseudo)
);
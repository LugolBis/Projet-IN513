-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Users';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Users (
    pseudo varchar(15) primary key on delete cascade,
    name varchar(30),
    surname varchar(30),
    mail varchar(30) not null,
    password varchar(30) not null,
    IPaddress varchar(15) not null,
    description varchar(160),
    ban_end date,
    ban_reason varchar(160)
);
-- Administrateur de la BD
-- C'est lui qui crée les tables, les vues, les triggers, etc.

create user admin identified by banane;
grant create session to admin;
grant unlimited tablespace to admin;
grant create table to admin;
grant create procedure to admin;
grant create user to admin;
grant create trigger to admin;
grant create view to admin;
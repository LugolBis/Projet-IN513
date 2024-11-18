-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW MyDraft';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la vue
create view MyDraft as
select * from Draft 
where pseudo=auth_pkg.CURRENT_USER
order by iddraft desc;
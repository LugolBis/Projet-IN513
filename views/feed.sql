-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW Feed';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la vue
create view Feed as
select * from Post
where pseudo in (select pseudo from Follow where follower=&CURRENT_USER) /* On sélectionne tous les pseudos suivis par l'utilisateur */
order by date_post desc;
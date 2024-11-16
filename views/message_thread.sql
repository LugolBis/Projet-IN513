-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW MessageThread';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

create view MessageThread as
select idpm 
from PrivateMessage
where idpm in (   -- On sélection l'id des messages 
   select PV.idpm 
   from PrivateMessage PV, Receive R
   where R.idpm=PV.idpm and R.pseudo=&CURRENT_USER and PV.sender=&TARGET_USER) 
or idpm in (
   select R.idpm
   from PrivateMessage PV, Receive R
   where R.idpm=PV.idpm and R.pseudo=&TARGET_USER and PV.sender=&CURRENT_USER)
order by idpm desc;
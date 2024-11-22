-- Procédure créant ou remplçant la vue MessageThread
-- Vue permettant de récupérer le fil de discussion entre l'utilisateur et un autre utilisateur donné

create or replace procedure get_message_thread(TARGET_USER in varchar2) as
begin
   execute immediate
   'create or replace view MessageThread as
    select idpm 
    from PrivateMessage
    where idpm in ( 
      select PV.idpm 
      from PrivateMessage PV, Receive R
      where R.idpm=PV.idpm and R.pseudo=lower(user) and PV.sender=' || TARGET_USER || ') 
    or idpm in (
      select R.idpm
      from PrivateMessage PV, Receive R
      where R.idpm=PV.idpm and R.pseudo=' || TARGET_USER || ' and PV.sender=lower(user))
    order by idpm desc;';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

/*
DEPRECATED

create view MessageThread as
select idpm 
from PrivateMessage
where idpm in (   -- On sélection l'id des messages 
   select PV.idpm 
   from PrivateMessage PV, Receive R
   where R.idpm=PV.idpm and R.pseudo=auth_pkg.CURRENT_USER and PV.sender=&TARGET_USER) 
or idpm in (
   select R.idpm
   from PrivateMessage PV, Receive R
   where R.idpm=PV.idpm and R.pseudo=&TARGET_USER and PV.sender=auth_pkg.CURRENT_USER)
order by idpm desc;
*/
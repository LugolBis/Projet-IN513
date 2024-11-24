-- Procédure créant ou remplaçant la vue Sanctions
-- Vue modélisant le temps restant avant la fin du banissement des utilisateurs bannis

create or replace procedure get_sanctions as
begin
   execute immediate
   'create or replace view Sanctions as
    select pseudo, ban_end - SYSDATE as time_left, ban_reason
    from Users
    where SYSDATE < ban_end';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

grant execute on admin.get_sanctions to client, moderator;

/*
DEPRECATED

create view Sanctions as
select pseudo, ban_end - SYSDATE as time_left, ban_reason
from Users
where SYSDATE < ban_end;
*/
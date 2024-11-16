-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW Sanctions';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
            RAISE;
        end if;
end;
/
-- Création de la vue
create view Sanctions as
select pseudo, ban_end - SYSDATE as time_left, ban_reason
from Users
where SYSDATE < ban_end;
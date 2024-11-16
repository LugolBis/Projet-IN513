-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW UrgentSignal';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

create view UrgentSignal as
select idpost
from Signal
group by idpost
having count(*)>=30;
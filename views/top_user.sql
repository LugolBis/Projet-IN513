-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW TopUser';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

create view TopUser as
select pseudo, count(*) as nb_followers
from Users left join Follow on Users.pseudo=Follow.pseudo
group by Users.pseudo
order by nb_followers desc;
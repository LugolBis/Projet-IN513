-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW RankPost';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

create view RankPost as
select sum(value) as rank,
    (select sum(value) from Vote where idpost=&ID_POST and value<0 group by idpost) as downvotes,
    (select sum(value) from Vote where idpost=&ID_POST and value>0 group by idpost) as downvotes
from Vote
where idpost=&ID_POST
group by idpost;
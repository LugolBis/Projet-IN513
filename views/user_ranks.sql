-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW Rank';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

create view Rank as
select Post.pseudo as pseudo, sum(Vote.value) as rank
from Post, Vote
where Post.idpm=Vote.idpm
group by Post.idpm
order by rank desc;
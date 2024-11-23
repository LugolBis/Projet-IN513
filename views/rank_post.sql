-- Procédure créant ou remplaçant la vue RankPost
-- Vue modélisant les statistiques d'un post donné

create or replace procedure get_rank_post(ID_POST in number) as
begin
   execute immediate
   'create or replace view RankPost as
    select sum(value) as rank,
    (select sum(value) from Vote where idpost = ' || ID_POST || ' and value < 0 group by idpost) as downvotes,
    (select sum(value) from Vote where idpost = ' || ID_POST || ' and value > 0 group by idpost) as upvotes
    from Vote
    where idpost = ' || ID_POST || '
    group by idpost';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

grant execute on admin.get_rank_post to client;

/*
DEPRECATED

create view RankPost as
select sum(value) as rank,
    (select sum(value) from Vote where idpost=&ID_POST and value<0 group by idpost) as downvotes,
    (select sum(value) from Vote where idpost=&ID_POST and value>0 group by idpost) as upvotes
from Vote
where idpost=&ID_POST
group by idpost;
*/
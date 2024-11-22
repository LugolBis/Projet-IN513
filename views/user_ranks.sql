-- Procédure créant ou remplaçant la vue Rank
-- Vue modélisant le rank de tous les utilisateurs

create or replace procedure get_rank as
begin
   execute immediate
   'create view Rank as
    select Post.pseudo as pseudo, sum(Vote.value) as rank
    from Post, Vote
    where Post.idpost = Vote.idpost
    group by Post.idpost, Post.pseudo
    order by rank desc;';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

/*
DEPRECATED

create view Rank as
select Post.pseudo as pseudo, sum(Vote.value) as rank
from Post, Vote
where Post.idpost = Vote.idpost
group by Post.idpost, Post.pseudo
order by rank desc;
*/
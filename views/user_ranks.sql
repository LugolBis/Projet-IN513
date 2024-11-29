-- Procédure créant ou remplaçant la vue Rank
-- Vue modélisant le rank de tous les utilisateurs

create or replace view Rank as
select Post.pseudo as pseudo, sum(Vote.value) as rank
from Post, Vote
where Post.idpost = Vote.idpost
group by Post.idpost, Post.pseudo
order by rank desc;

grant select on Rank to client, moderator;
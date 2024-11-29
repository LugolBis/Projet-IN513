-- Procédure créant ou remplaçant la vue RankPost
-- Vue modélisant les statistiques d'un post donné

create or replace view RankPost as
select sum(value) as rank,
   sum(case when Vote.value > 0 then 0 else 1 end) as downvotes,
   sum(case when Vote.value > 0 then 1 else 0 end) as upvotes
from Vote
group by idpost;

grant select on RankPost to client, moderator;
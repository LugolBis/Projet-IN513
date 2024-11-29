-- Procédure créant ou remplaçant la vue MyDraft
-- Vue modélisant les brouilons (drafts) de l'utilsateur

create or replace view MyDraft as
select * 
from Draft 
where pseudo = lower(user)
order by iddraft desc;

grant select on MyDraft to client, moderator;
-- Procédure créant ou remplaçant la vue TopUser
-- Vue modélisant le classement des utilisateurs les plus suivis

create or replace view TopUser as
select Users.pseudo, count(*) as nb_followers
from Users left join Follow on Users.pseudo=Follow.pseudo
group by Users.pseudo
order by nb_followers desc;

grant select on TopUser to client, moderator;
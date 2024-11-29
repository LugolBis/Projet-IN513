-- Procédure créant ou remplaçant la vue Sanctions
-- Vue modélisant le temps restant avant la fin du banissement des utilisateurs bannis

create or replace view Sanctions as
select pseudo, ban_end - SYSDATE as time_left, ban_reason
from Users
where SYSDATE < ban_end;

grant select on Sanctions to client, moderator;
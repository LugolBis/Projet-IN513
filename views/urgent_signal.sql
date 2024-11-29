-- Procédure créant ou remplaçant la vue UrgentSignal
-- Vue modélisant les posts signalés plus de 30 fois

create or replace view UrgentSignal as
select idpost
from Signal
group by idpost
having count(*) >= 30;

grant select on UrgentSignal to moderator;
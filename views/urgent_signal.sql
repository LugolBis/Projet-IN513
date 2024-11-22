-- Procédure créant ou remplaçant la vue UrgentSignal
-- Vue modélisant les posts signalés plus de 30 fois

create or replace procedure get_urgent_signal as
begin
   execute immediate
   'create or replace view UrgentSignal as
    select idpost
    from Signal
    group by idpost
    having count(*)>=30';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

/*
DEPRECATED

create view UrgentSignal as
select idpost
from Signal
group by idpost
having count(*)>=30;
*/
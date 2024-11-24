-- Procédure créant ou remplaçant la vue MyDraft
-- Vue modélisant les brouilons (drafts) de l'utilsateur

create or replace procedure get_my_draft as
begin
   execute immediate
   'create or replace view MyDraft as
    select * from Draft 
    where pseudo=lower(user)
    order by iddraft desc';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

grant execute on admin.get_my_draft to client;
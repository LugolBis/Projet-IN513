-- Vue modélisant le fil d'actualité de l'utilisateur

create or replace procedure get_feed as
begin
   execute immediate
   'create or replace view Feed as
    select * from Post
    where pseudo in (select pseudo from Follow where follower=lower(user))
    order by date_post desc';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

grant execute on admin.get_feed to client, moderator;
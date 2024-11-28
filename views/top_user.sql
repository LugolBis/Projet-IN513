-- Procédure créant ou remplaçant la vue TopUser
-- Vue modélisant le classement des utilisateurs les plus suivis

create or replace procedure get_top_user as
begin
   execute immediate
   'create or replace view TopUser as
    select Users.pseudo, count(*) as nb_followers
    from Users left join Follow on Users.pseudo=Follow.pseudo
    group by Users.pseudo
    order by nb_followers desc';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

grant execute on admin.get_top_user to client, moderator;

/*
DEPRECATED

create view TopUser as
select Users.pseudo, count(*) as nb_followers
from Users left join Follow on Users.pseudo=Follow.pseudo
group by Users.pseudo
order by nb_followers desc;
*/
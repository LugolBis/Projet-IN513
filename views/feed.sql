-- Vue modélisant le fil d'actualité de l'utilisateur

create or replace view Feed as
select * from Post
where pseudo in (select pseudo from Follow where follower=lower(user))
order by date_post desc;

grant select on Feed to client, moderator;
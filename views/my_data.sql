create or replace view MyData as
select *
from Users
where pseudo = lower(user);

grant select, update on MyData to client, moderator;
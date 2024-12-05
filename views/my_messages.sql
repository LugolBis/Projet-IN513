create or replace view MyMessages as select
	pm.sender as sender, r.pseudo as recipient, pm.message
from
	PrivateMessage pm, Receive r
where
	pm.idpm = r.idpm and
	(pm.sender = lower(user) or r.pseudo = lower(user));

grant select on MyMessages to client, moderator;
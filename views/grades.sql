-- Procédure créant ou remplaçant la vue Influencer
-- Vue modélisant les utilisateurs faisant parti du N%
-- des utilisateurs en fonction de leur rank


-- grant select on Goat to client, moderator;

create or replace function get_user_count return number as
	n number := 0;
begin
	select
		count(pseudo) into n
	from
		Rank;

	return n;
end;
/

create or replace view Goat as select
	pseudo, rank
from
	Rank
where
	rownum <= 0.1 * get_user_count;

create or replace view Influencer as select
	pseudo, rank
from
	Rank
where
	rownum > 0.1 * get_user_count and
	rownum <= 0.5 * get_user_count;

create or replace view Nobody as select
	pseudo, rank
from
	Rank
where
	rownum > 0.5 * get_user_count;


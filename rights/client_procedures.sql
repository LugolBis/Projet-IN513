-- Renvoie 1 si le dernier post de l'utilisateur actuel date
-- d'au moins deux secondes, 0 sinon.
create or replace function is_post_cooldown_up return number as
	max_date date := current_date;
	delay number  := 0.0;
begin
	select
		max(date_post) into max_date
	from
		Post
	where
		upper(pseudo) = user;

	delay := current_date - max_date;
	-- Conversion en secondes
	delay := delay * 24 * 3600;

	if delay > 2.0 then
		return 1;
	else
		return 0;
	end if;
end;
/

create or replace procedure add_hashtag(hashtag IN varchar, post IN varchar) as
	occurences number := 0;
begin
	select
		count(content) into occurences
	from Hashtag where content = hashtag;

	if occurences = 0 then
		insert into Hashtag values (hashtag);
	end if;

	insert into HasHashtag values (post, hashtag);
end;
/

-- Insère tous les mots précédés par un '#' dans la table 
-- Hashtag.
create or replace procedure parse_hashtags(post IN varchar) as
	msg varchar(280) := 'none';
	parser_state number(1) := 0;
	buffer varchar(140) := 'none';
	c varchar(1) := '_';
begin
	-- Récupération du text du post dans msg.
	select
		message into msg
	from
		Post
	where
		idpost = post;

	-- Parsing:
	--  - Etat 0: Recherche du caractère '#'
	--	- Etat 1: Récupération du hashtag dans buffer
	for i in 1..length(msg) loop
		c := substr(msg, i, 1);
		if parser_state = 0 and c = '#' then
			parser_state := 1;
		elsif c = ' ' or i = length(msg)-1 then
				add_hashtag(buffer, post);
				buffer := '';
				parser_state := 0;
			else
				buffer := buffer || c;
			end if;
		end if;
	end loop;

end;
/

-- Seul et unique moyen d'ajouter des posts dans la base de donnée
-- pour l'utilisateur lambda.
create or replace procedure add_post(msg IN varchar, room IN varchar, building IN varchar) as
	id varchar(32) := 'none';
begin
	if is_post_cooldown_up = 1 then
		raise_application_error(-20589, 'Please wait at least 2 seconds before posting again.');
	else
		id := sys_guid();
		insert into Post values (id, msg, current_date, room, building, lower(user));
		parse_hashtags(id);
	end if;
end;
/
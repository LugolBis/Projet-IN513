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
	buffer varchar(140) := '';
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
			buffer := '';
		else
			if parser_state = 1 and (c = ' ' or i = length(msg)-1) then
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

create or replace function new_idpost return number as
	m_id number(6) := 0;
	c_post number(6) := 0;
begin
	select
		count(idpost) into c_post
	from
		Post;

	if c_post = 0 then
		return 0;
	else
		select
			max(idpost) into m_id
		from
			Post;

		return m_id + 1;
	end if;

end;
/

-- Ajout de la location d'un post
create or replace procedure update_location(room in varchar, buiding in varchar) as
begin
	update Post set room = room, building = building
	where pseudo = lower(user);
end;
/

-- Seul et unique moyen d'ajouter des posts dans la base de donnée
-- pour l'utilisateur lambda.
create or replace procedure add_post(msg IN varchar, room IN varchar, building IN varchar) as
	id varchar(32) := 'none';
begin
	if is_post_cooldown_up = 0 then
		raise_application_error(-20589, 'Please wait at least 2 seconds before posting again.');
	else
		insert into Post values (new_idpost, msg, current_date, room, building, lower(user));
		parse_hashtags(id);
	end if;
end;
/

-- Permet à l'utilisateur de modifier l'attribut validate de l'un de ses brouillons (draft)
create or replace procedure validate_draft(id in number, state in boolean) as
begin
	update Draft set state = state where iddraft = id;
end;
/

/*
Seconde implémentation de la procedure validate_draft qui rendrait obsolète le trigger 'post_draft'

create or replace procedure(id number, validate in boolean) as
	MESSAGE varchar(280);
begin
	if validate = TRUE then
		select message into MESSAGE
		from Draft
		where iddraft = id;

		user.add_post(MESSAGE, null, null);
	else
		delete from Daft where iddraft = :new.iddraft;
	end if;
end;
/
*/
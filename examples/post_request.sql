-- Requêtes concernant les Posts

-- R8
create or replace procedure get_post_target_user(TARGET_USER in varchar2) as
begin
    select *
    from Post
    where pseudo = TARGET_USER
    order by date_post desc;
end;
/

-- R9
create or replace procedure get_post_target_location(BUILDING in varchar2, ROOM in varchar2) as
begin
    if BUILDING = 'null' then
        select *
        from Post
        where room = ROOM
        order by date_post desc;
    else if ROOM = 'null' then
        select *
        from Post
        where building = BUILDING
        order by date_post desc;
    else
        select *
        from Post
        where building = BUILDING and room = ROOM
        order by date_post desc;
    end if;
end;
/

-- R10
create or replace procedure get_post_time(DATE_START in date, DATE_END in date) as
begin
    select *
    from Post
    where date_post between DATE_START and DATE_END
    order by date_post desc;
end;
/

-- R11
create or replace procedure get_some_post(N in number) as
begin
    select *
    from Post
    order by date_post desc
    fetch first N rows only;
end;
/

-- R12
create or replace function word_parser(CONTENT in varchar2) as
begin




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
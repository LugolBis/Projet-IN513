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
create or replace function word_parser(CONTENT in varchar2, WORD in varchar) return boolean as
begin
	buffer varchar(140) := '';
	c varchar(1) := '_';

    return REGEXP_LIKE(CONTENT, WORD);
    /*
	for i in 1..length(CONTENT) loop
		c := substr(CONTENT, i, 1);
        if c is in ('.', ',', '!', '?', ':', ';', "'", '"', '(', ')', '[', ']', '{', '}','-', '_', '=', '+', '*', '/', '\\',  
        '|', '<', '>', '~', '`', '@', '#', '$', '%', '^', '&', ' ') then
            if buffer = WORD then
                return TRUE;
            else
                buffer := '';
            end if;
        end if;
    end loop;
    return FALSE; */
end;
/

create or replace procedure post_with_word(WORD in varchar2) as
begin
    select *
    from Post
    where word_parser(message) = TRUE
    order by date_post desc;
end;
/

-- R13
create or replace procedure post_with_hashtag(HASHTAG in varchar2) as
begin
    select *
    from Post
    where idpost in (
        select idpost 
        from HasHashtag
        where hashtag=HASHTAG)
    order by date_post desc;
end;
/
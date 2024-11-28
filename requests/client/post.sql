-- Requêtes concernant les Posts

-- R8 : Quels sont les récents posts de [TARGET_USER] ?
create or replace procedure get_post_target_user(TARGET_USER in varchar2) as
begin
    execute immediate
    'select *
     from Post
     where pseudo = ' || TARGET_USER || '
     order by date_post desc';
end;
/

-- R9 : Quels sont les post émis depuis [BUILDING] et/ou [ROOM] ?
create or replace procedure get_post_target_location(BUILDING in varchar2, ROOM in varchar2) as
begin
    if BUILDING = 'null' then
        execute immediate
        'select *
         from Post
         where room = ' || ROOM || '
         order by date_post desc';
    elsif ROOM = 'null' then
        execute immediate
        'select *
         from Post
         where building = ' || BUILDING || '
         order by date_post desc';
    else
        execute immediate
        'select *
         from Post
         where building = ' || BUILDING || ' and room = ' || ROOM || '
         order by date_post desc';
    end if;
end;
/

-- R10 : Quels sont les posts postés entre [DATE_START] et [DATE_END] ?
create or replace procedure get_post_time(DATE_START in date, DATE_END in date) as
begin
    execute immediate
    'select *
     from Post
     where date_post between ' || DATE_START || ' and ' || DATE_END || '
     order by date_post desc';
end;
/

-- R11 : Quels sont les [N] posts les plus récents ?
create or replace procedure get_some_post(N in number) as
begin
    execute immediate
    'select *
     from Post
     order by date_post desc
     fetch first ' || N || ' rows only';
end;
/

-- R12 : Quels sont les posts contenant [WORD] ?

-- Fonction pour vérifier si un mot est contenu dans la chaîne de caractère passée en entrée
create or replace function word_parser(CONTENT in varchar2, WORD in varchar2) return boolean as
    RESULT boolean;
begin
    select REGEXP_LIKE(CONTENT, WORD, 'i') into RESULT
    from dual;

    return RESULT;
end;
/

create or replace procedure post_with_word(WORD in varchar2) as
begin
    execute immediate
    'select *
     from Post
     where word_parser(message, ''' || WORD || ''') = TRUE
     order by date_post desc';
end;
/

-- R13 : Quels sont les posts utilisant [HASHTAG] ?
create or replace procedure post_with_hashtag(HASHTAG in varchar2) as
begin
    execute immediate
    'select *
     from Post
     where idpost in (
         select idpost 
         from HasHashtag
         where hashtag= ' || HASHTAG || ')
     order by date_post desc';
end;
/

-- R14 : Quels sont les posts les plus upvoté (ou downvoté) ?
create or replace procedure post_most_upvoted as
begin
    execute immediate
    'select P.idpost, P.message, P.date_post, P.room, P.building, P.pseudo, count(*) as rank
     from Post P, Vote V
     where P.idpost = V.idpost and V.value = 1
     group by P.idpost
     order by rank desc';
end;
/

create or replace procedure post_most_downvoted as
begin
    execute immediate
    'select P.idpost, P.message, P.date_post, P.room, P.building, P.pseudo, count(*) as rank
     from Post P, Vote V
     where P.idpost = V.idpost and V.value = -1
     group by P.idpost
     order by rank';
end;
/
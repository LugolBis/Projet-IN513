-- R15 : Quels utilisateurs ont utilisé les hashtags en tendance 
create or replace procedure get_post_hashtags_tendance as
begin
    execute immediate
    'select pseudo
     from Post 
     where date_post >= SYSDATE-7
     and idpost in (
         select idpost
         from HasHashtag
         where hashtag in (
             select hashtag
             from Tendance
         )
     )
     order by date_post desc';
end;
/

-- R16 : Quelle est la proportion de hashtags en tendance utilisés par [TARGET_USER] ?
create or replace function get_proportion_hashtag(TARGET_USER in varchar2) return number as
    total_hashtags number(6);
    total_tendance number(6);
begin
    select count(*) into total_hashtags
    from Post
    where date_post >= SYSDATE-7
    and pseudo = TARGET_USER
    and idpost in (
        select idpost
        from HasHashtag
    );


    select count(*) into total_tendance
    from Post
    where date_post >= SYSDATE-7
    and pseudo = TARGET_USER
    and idpost in (
        select idpost
        from HasHashtag
        where hashtag in (
            select hashtag
            from Tendance
        )
    );

    if total_hashtags < 1 then
        return 0;
    else
        return (total_tendance*100)/total_hashtags;
    end if;
end;
/

-- R18 : Quel est le jour durant lequel un hashtag [HASHTAG] a été le plus posté ?
create or replace function get_hashtag_day(HASHTAG in varchar2) return date as
    DATE_RESULT date := SYSDATE;
begin
    select trunc(P.date_post) into DATE_RESULT
    from Post P, HasHashtag HH
    where HH.idpost = P.idpost and HH.hashtag = HASHTAG
    group by trunc(P.date_post)
    order by count(*) desc
    fetch first 1 rows only;

    return DATE_RESULT;
end;
/
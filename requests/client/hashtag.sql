-- R15 : Quels utilisateurs ont utilisé les hashtags en tendance 
select pseudo
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
order by date_post desc;

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

-- R17 : Quel sont les hashtags les plus fréquemment postés avec le hashtag [a] ?
create or replace function max_frequency_hashtag(HASHTAG in varchar)
return number as
    RESULT number(6);
begin
    select count(*) into RESULT
    from HasHashtag h1, HasHashtag h2
    where h1.idpost = h2.idpost
    and h1.hashtag = HASHTAG
    and h2.hashtag != HASHTAG
    group by h2.hashtag;

    return RESULT;
end;
/

select h2.hashtag, count(*) as occurence
from HasHashtag h1, HasHashtag h2
where h1.idpost = h2.idpost
and h1.hashtag = 'Élection'
and h2.hashtag != 'Élection'
group by h2.hashtag
having occurence = max_frequency_hashtag('Élection')
order by occurence desc;

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
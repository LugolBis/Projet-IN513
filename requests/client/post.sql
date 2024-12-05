-- Requêtes concernant les Posts

-- R8 : Quels sont les récents posts de [TARGET_USER] ?
select *
from Post
where pseudo = 'lulu'
order by date_post desc;

-- R9 : Quels sont les post émis depuis [BUILDING] et/ou [ROOM] ?
select *
from Post
where building = 'Fermat'
and room = 'Amphi J'
order by date_post desc;

-- R10 : Quels sont les posts postés entre [DATE_START] et [DATE_END] ?
select *
from Post
where date_post between date '2012-08-30' and date '2012-10-11'
order by date_post desc;

-- R11 : Quels sont les [N] posts les plus récents ?
select *
from Post
order by date_post desc
fetch first 15 rows only;

-- R12 : Quels sont les posts contenant [WORD] ?

-- Fonction pour vérifier si un mot est contenu dans la chaîne de caractère passée en entrée
select *
from Post
where REGEXP_LIKE(message, 'Banane', 'i') = TRUE
order by date_post desc;

-- R13 : Quels sont les posts utilisant [HASHTAG] ?
select *
from Post
where idpost in (
    select idpost 
    from HasHashtag
    where hashtag= '#VacancesBFF')
order by date_post desc;

-- R14 : Quels sont les posts les plus upvoté (ou downvoté) ?
select P.idpost, P.message, P.date_post, P.room, P.building, P.pseudo, NVL(V.rank, 0) as rank
from Post P
left join (
    select V.idpost, count(V.pseudo) as rank
    from Vote V
    where V.value = 1
    group by V.idpost
) V
on P.idpost = V.idpost
order by rank desc;

select P.idpost, P.message, P.date_post, P.room, P.building, P.pseudo, NVL(V.rank, 0) as rank
from Post P
left join (
    select V.idpost, count(V.pseudo) as rank
    from Vote V
    where V.value = -1
    group by V.idpost
) V
on P.idpost = V.idpost
order by rank desc;
-- REQUÊTES UTILISATEURS

-- 1 - Quelle est la liste des hashtags utilisés par [TARGET_USER] ?
select distinct HH.hashtag
from admin.HasHashtag HH, admin.Post P
where HH.idpost = P.idpost
and P.pseudo = 'lulu';

-- 2 - Quelle est la moyenne des votes des posts de [TARGET_USER] ?
create or replace function get_average_rank_post(TARGET_USER in varchar2)
return number as
    RESULT number(7) := 0;
begin
    select avg(V.value) into RESULT
    from Vote V, Post P
    where V.idpost = P.idpost
    and P.pseudo = TARGET_USER;

    return RESULT;
end;
/

-- 3 - Est-ce que [pseudo] est suivi par au moins un des utilisateurs que je suis ?
create or replace function get_linked_user(TARGET_USER in varchar2)
return boolean as
    RESULT number(6);
begin
    select count(*) into RESULT
    from admin.Follow F1, admin.Follow F2
    where F1.follower = F2.pseudo
    and F1.pseudo = TARGET_USER
    and F2.follower = lower(user);

    return RESULT > 0;
end;
/

-- 4 - Quels sont les utilisateurs que je suis et qui me suivent ?
SELECT F1.follower AS mutual_follow
FROM admin.Follow F1, admin.Follow F2
WHERE F1.follower = F2.pseudo
AND F1.pseudo = lower(user) AND F2.follower = lower(user);

-- 5 - Quels sont les utilisateurs qui suivent [pseudo] ET qui sont suivis par [pseudo] ?
SELECT F1.follower AS mutual_follow
FROM admin.Follow F1
JOIN admin.Follow F2 ON F1.follower = F2.pseudo
WHERE F1.pseudo = 'jojo' AND F2.follower = 'lulu';

-- 6 - Quels sont les utilisateurs que je suis mais qui ne me suivent pas ?
SELECT F1.follower AS not_following_back
FROM admin.Follow F1
LEFT JOIN admin.Follow F2 ON F1.follower = F2.pseudo AND F2.follower = lower(user)
WHERE F1.pseudo = lower(user) AND F2.pseudo IS NULL;

-- 7 - Quel est l'utilisateur qui approuve/désapprouve le plus de mes posts ?
select V.pseudo, sum(V.value) as upvotes
from admin.Vote V, admin.Post P
where V.idpost = P.idpost
and V.value > 0 and P.pseudo = lower(user)
group by V.pseudo
having upvotes > 0
order by upvotes desc;

select V.pseudo, sum(V.value) as downvotes
from admin.Vote V, admin.Post P
where V.idpost = P.idpost
and V.value < 0 and P.pseudo = lower(user)
group by V.pseudo
having downvotes > 0
order by downvotes desc;
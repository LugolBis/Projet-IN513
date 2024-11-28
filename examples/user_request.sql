-- REQUÊTES UTILISATEURS

-- 1 - Quelle est la liste des hashtags utilisés par [TARGET_USER] ?
create or replace procedure get_hashtag_used(TARGET_USER in varchar2) as
begin
    execute immediate
    'select distinct HH.hashtag
     from HasHashtag HH, Post P
     where HH.idpost = P.idpost
     and P.pseudo = '''||TARGET_USER||''' ';
end;
/


/*
DEPRECATED

SELECT DISTINCT HasHashtag.hashtag
FROM HasHashtag
JOIN Post ON HasHashtag.idpost = Post.idpost
WHERE Post.user = '[pseudo]'; */

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

/*
DEPRECATED

SELECT AVG(Vote.value) AS average_vote
FROM Vote
JOIN Post ON Vote.idpost = Post.idpost
WHERE Post.user = '[pseudo]';*/

-- 3 - Est-ce que [pseudo] est suivi par au moins un des utilisateurs que je suis ?
create or replace function get_linked_user(TARGET_USER in varchar2)
return boolean as
    RESULT boolean;
begin
    SELECT EXISTS (
        SELECT 1
        FROM Follow AS F1
        JOIN Follow AS F2 ON F1.follower = F2.pseudo
        WHERE F1.pseudo = TARGET_USER AND F2.follower = lower(user)
    ) INTO RESULT;

    return RESULT;
end;
/

-- 4 - Quels sont les utilisateurs que je suis et qui me suivent ?
create or replace procedure get_mutual_follower as
begin
    execute immediate
    'SELECT F1.follower AS mutual_follow
     FROM Follow F1, Follow F2
     WHERE F1.follower = F2.pseudo
     AND F1.pseudo = lower(user) AND F2.follower = lower(user)';
end;
/

-- 5 - Quels sont les utilisateurs qui suivent [pseudo] ET qui sont suivis par [pseudo] ?
create or replace procedure get_followers
(TARGET_USER1 in varchar2, TARGET_USER2 in varchar2) as
begin
    execute immediate
    'SELECT F1.follower AS mutual_follow
    FROM Follow AS F1
    JOIN Follow AS F2 ON F1.follower = F2.pseudo
    WHERE F1.pseudo = '''||TARGET_USER1||''' AND F2.follower = '''||TARGET_USER2||''' ';
end;
/

-- 6 - Quels sont les utilisateurs que je suis mais qui ne me suivent pas ?
create or replace procedure get_impostors as
begin
    execute immediate
    'SELECT F1.follower AS not_following_back
    FROM Follow AS F1
    LEFT JOIN Follow AS F2 ON F1.follower = F2.pseudo AND F2.follower = lower(user)
    WHERE F1.pseudo = lower(user) AND F2.pseudo IS NULL';
end;
/

-- 7 - Quel est l'utilisateur qui approuve/désapprouve le plus de mes posts ?
create or replace procedure get_fans as
begin
    execute immediate
    'select V.pseudo, sum(V.value) as upvotes
     from Vote V, Post P
     where V.idpost = P.idpost
     and V.value > 0 and P.pseudo = lower(user)
     group by V.pseudo
     having upvotes > 0
     order by upvotes desc';
end;
/

create or replace procedure get_haters as
begin
    execute immediate
    'select V.pseudo, sum(V.value) as downvotes
     from Vote V, Post P
     where V.idpost = P.idpost
     and V.value < 0 and P.pseudo = lower(user)
     group by V.pseudo
     having downvotes > 0
     order by downvotes desc';
end;
/

/*
DEPRECATED

SELECT Vote.user, 
       SUM(CASE WHEN Vote.value > 0 THEN 1 ELSE 0 END) AS approvals,
       SUM(CASE WHEN Vote.value < 0 THEN 1 ELSE 0 END) AS disapprovals
FROM Vote
JOIN Post ON Vote.idpost = Post.idpost
WHERE Post.user = '[Mon_pseudo]'
GROUP BY Vote.user
ORDER BY GREATEST(SUM(CASE WHEN Vote.value > 0 THEN 1 ELSE 0 END), 
                  SUM(CASE WHEN Vote.value < 0 THEN 1 ELSE 0 END)) DESC
LIMIT 1; */


-- Droits d'éxécution des procédures/fonctions :
grant execute on get_hashtag_used to client, moderator;
grant execute on get_average_rank_post to client, moderator;
grant execute on get_linked_user to client, moderator;
grant execute on get_mutual_follower to client, moderator;
grant execute on get_followers to client, moderator;
grant execute on get_impostors to client, moderator;
grant execute on get_fans to client, moderator;
grant execute on get_haters to client, moderator;
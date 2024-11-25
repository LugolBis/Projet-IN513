--                REQUÊTES UTILISATEURS

-- 1 - Quelle est la liste des hashtags utilisés par [pseudo] ?

SELECT DISTINCT HasHashtag.hashtag
FROM HasHashtag
JOIN Post ON HasHashtag.idpost = Post.idpost
WHERE Post.user = '[pseudo]';

-- 2 - Quelle est la moyenne des votes des posts de [pseudo] ?

SELECT AVG(Vote.value) AS average_vote
FROM Vote
JOIN Post ON Vote.idpost = Post.idpost
WHERE Post.user = '[pseudo]';

-- 3 - Est-ce que [pseudo] est suivi par au moins un des utilisateurs que je suis ?

SELECT EXISTS (
    SELECT 1
    FROM Follow AS F1
    JOIN Follow AS F2 ON F1.follower = F2.pseudo
    WHERE F1.pseudo = '[pseudo]' AND F2.follower = '[Mon_pseudo]'
) AS is_followed;

-- 4 - Quels sont les utilisateurs que je suis et qui me suivent ?

SELECT F1.follower AS mutual_follow
FROM Follow AS F1
JOIN Follow AS F2 ON F1.follower = F2.pseudo
WHERE F1.pseudo = '[Mon_pseudo]' AND F2.follower = '[Mon_pseudo]';

-- 5 - Quels sont les utilisateurs qui suivent [pseudo] ET qui sont suivis par [pseudo] ?

SELECT F1.follower AS mutual_follow
FROM Follow AS F1
JOIN Follow AS F2 ON F1.follower = F2.pseudo
WHERE F1.pseudo = '[pseudo]' AND F2.follower = '[pseudo]';

-- 6 - Quels sont les utilisateurs que je suis mais qui ne me suivent pas ?

SELECT F1.follower AS not_following_back
FROM Follow AS F1
LEFT JOIN Follow AS F2 ON F1.follower = F2.pseudo AND F2.follower = '[Mon_pseudo]'
WHERE F1.pseudo = '[Mon_pseudo]' AND F2.pseudo IS NULL;

-- 7 - Quel est l'utilisateur qui approuve/désapprouve le plus de mes posts ?

SELECT Vote.user, 
       SUM(CASE WHEN Vote.value > 0 THEN 1 ELSE 0 END) AS approvals,
       SUM(CASE WHEN Vote.value < 0 THEN 1 ELSE 0 END) AS disapprovals
FROM Vote
JOIN Post ON Vote.idpost = Post.idpost
WHERE Post.user = '[Mon_pseudo]'
GROUP BY Vote.user
ORDER BY GREATEST(SUM(CASE WHEN Vote.value > 0 THEN 1 ELSE 0 END), 
                  SUM(CASE WHEN Vote.value < 0 THEN 1 ELSE 0 END)) DESC
LIMIT 1;



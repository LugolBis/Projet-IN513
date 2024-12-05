create role moderator;
grant create session to moderator;
grant create view to moderator;

-- Ajouter l'accès aux procédures ici
grant execute on admin.add_user to moderator;

grant select on Post, Survey, Options, Follow, Vote, Hashtag, HasHashtag to moderator;

-- Moderateurs test, normalement les moderateurs doivent
-- être crées par l'admin.
create user modo1 identified by peche;
grant moderator to modo1;
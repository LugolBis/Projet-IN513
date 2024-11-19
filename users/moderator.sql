create role moderator;
grant create session to moderator;

-- Ajouter l'accès aux procédures ici

-- Moderateurs test, normalement les moderateurs doivent
-- être crées par l'admin.
create user modo1 identified by peche;
grant moderator to modo1;
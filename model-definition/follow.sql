-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE Follow';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table Follow(
    -- pseudo référence le pseudo d'un utilisateur
    pseudo varchar(15),
    -- follower référence le ou les utilisateur(s) qui suivent 'pseudo'             
    follower varchar(15),
    primary key (pseudo, follower),
    foreign key (pseudo) references Users(pseudo),
    foreign key (follower) references Users(follower)
);
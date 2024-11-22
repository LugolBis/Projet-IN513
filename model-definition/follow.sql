-- Création de la table
create table Follow(
    -- pseudo référence le pseudo d'un utilisateur
    pseudo varchar(15),
    -- follower référence le ou les utilisateur(s) qui suivent 'pseudo'             
    follower varchar(15),
    primary key (pseudo, follower),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (follower) references Users(pseudo) on delete cascade
);

alter table Follow add constraint follow_self check (pseudo!=follower);
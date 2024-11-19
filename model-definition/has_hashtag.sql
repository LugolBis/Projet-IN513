-- Création de la table
create table HasHashtag(
    idpost varchar(32),
    hashtag varchar(140),
    primary key (idpost, hashtag),
    foreign key (idpost) references Post(idpost) on delete cascade,
    foreign key (hashtag) references Hashtag(content) on delete cascade
);
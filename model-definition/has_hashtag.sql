-- Supression de la table
begin
   EXECUTE IMMEDIATE 'DROP TABLE HasHashtag';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la table
create table HasHashtag(
    idpost Number(5),
    hashtag varchar(140),
    primary key (idpost, hashtag),
    foreign key (idpost) references Post(idpost),
    foreign key (hashtag) references Hashtag(name)
);
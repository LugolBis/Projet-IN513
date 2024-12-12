-- Création du schéma de la BDD

-- Suppression des tables :

-- HasHashtag
begin
   EXECUTE IMMEDIATE 'DROP TABLE HasHashtag';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Hashtag
begin
   EXECUTE IMMEDIATE 'DROP TABLE Hashtag';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Answer
begin
   EXECUTE IMMEDIATE 'DROP TABLE Answer';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Signal
begin
   EXECUTE IMMEDIATE 'DROP TABLE Signal';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Vote
begin
   EXECUTE IMMEDIATE 'DROP TABLE Vote';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Draft
begin
   EXECUTE IMMEDIATE 'DROP TABLE Draft';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Follow
begin
   EXECUTE IMMEDIATE 'DROP TABLE Follow';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Receive
begin
   EXECUTE IMMEDIATE 'DROP TABLE Receive';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- PrivateMessage
begin
   EXECUTE IMMEDIATE 'DROP TABLE PrivateMessage';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Options
begin
   EXECUTE IMMEDIATE 'DROP TABLE Options';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Survey
begin
   EXECUTE IMMEDIATE 'DROP TABLE Survey';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Post
begin
   EXECUTE IMMEDIATE 'DROP TABLE Post';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Users
begin
   EXECUTE IMMEDIATE 'DROP TABLE Users';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

-- Création des tables :

create table Users (
    pseudo varchar(15) primary key,
    name varchar(30),
    surname varchar(30),
    mail varchar(64) not null,
    IPaddress varchar(15) not null,
    description varchar(160),
    ban_end date,
    ban_reason varchar(160)
);

create table Post (
    idpost number(6) primary key,
    message varchar(280) not null,
    date_post date not null,
    room varchar(20),
    building varchar(20),
    pseudo varchar(15),
    foreign key (pseudo) references Users(pseudo) on delete cascade
);

create table Survey(
    idsurvey Number(6) primary key,
    question varchar(280) not null,
    idpost number(6),
    foreign key (idpost) references Post(idpost) on delete cascade
);

create table Options(
    idoption Number(6) primary key,
    content varchar(150) not null,
    idsurvey Number(6),
    foreign key (idsurvey) references Survey(idsurvey) on delete cascade
);

create table PrivateMessage(
    idpm Number(6) primary key,
    message varchar(280) not null,
    date_send date not null,
    sender varchar(15),
    foreign key (sender) references Users(pseudo) on delete cascade
);

create table Receive(
    idpm Number(6),
    pseudo varchar(15),
    primary key (idpm, pseudo),
    foreign key (pseudo) references Users(pseudo) on delete cascade
);

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

create table Draft(
    iddraft Number(5) primary key,
    message varchar(280),
    pseudo varchar(15),
    state boolean,
    foreign key (pseudo) references Users(pseudo) on delete cascade
);

create table Vote(
    pseudo varchar(15),
    idpost number(6),
    value Number(1) not null,
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idpost) references Post(idpost) on delete cascade
);

create table Signal(
    pseudo varchar(15),
    idpost number(6),
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idpost) references Post(idpost) on delete cascade
);

create table Answer(
    pseudo varchar(15),
    idoption Number(6),
    primary key (pseudo, idoption),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idoption) references Options(idoption) on delete cascade
);

create table Hashtag(
    content varchar(140) primary key
);

create table HasHashtag(
    idpost number(6),
    hashtag varchar(140),
    primary key (idpost, hashtag),
    foreign key (idpost) references Post(idpost) on delete cascade,
    foreign key (hashtag) references Hashtag(content) on delete cascade
);
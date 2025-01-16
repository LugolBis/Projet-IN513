# Projet - IN513

<br>

# Cahier des charges

## Contexte
L'application modélisée par la base de données est un réseau social à l’échelle de l’université. Les utilisateurs peuvent poster des messages ou des sondages sur 
un mur et envoyer des messages à d'autres utilisateurs. Le projet se concentre sur la gestion de bout en bout d'une base de donnée complexe et 
dynamique (d'où l'absence de frontend).
<br>
<br>
La base de données à été déployée sous ***Oracle Database 23ai***.

## Modèle Relationnel

**Users** (**pseudo**, name, surname, mail, IPaddress, description, ban_end, ban_reason)<br>
**Post** (**idpost**, message, date_post, room, building, *pseudo*)<br>
**Survey** (**idsurvey**, question, *idpost*)<br>
**Options** (**idoption**, content, *idsurvey*)<br>
**PrivateMessage** (**idpm**, message, date, *sender*)<br>
<br>
**Receive** (***idpm***, ***pseudo***)<br>
**Follow** (***pseudo***, ***follower***)<br>
**Draft** (**iddraft**, message, *pseudo*)<br>
**Vote** (***pseudo***, ***idpost***, value)<br>
**Signal** (***pseudo***, ***idpost***)<br>
**Answer** (***pseudo***, ***idoption***)<br>
**Hashtag** (*content*)<br>
**HasHashtag** (***idpost***, ***hashtag***)<br>

## Définition des tables

```SQL
-- PL/SQL

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
```

## Utilisateurs

Les utilisateurs sont encouragés à interagir avec les messages du mur en choisissant de les “upvoter” ou de les “downvoter” 
(équivalents au “like”/”dislike” des plateformes plus connues) ou en les signalant dans le cas de contenu choquant ou irrévérencieux.
```SQL
-- PL/SQL

-- Génère  un nouvel ID pour un post
create or replace function new_idpost return number AS
	RESULT number(6);
begin
	select NVL(max(idpost)+1, 0) into RESULT
	from Post;

	return RESULT;
end;
/

-- Permet d'ajouter un nouveau vote 
create or replace procedure add_vote(ID_POST in number, IS_LIKE in boolean) as
begin
	if IS_LIKE = TRUE then
		insert into Vote values(lower(user),ID_POST,1);
	else
		insert into Vote values(lower(user),ID_POST,-1);
	end if;
end;
/

-- Ajout de la location d'un post
create or replace procedure update_location(room in varchar, buiding in varchar) as
begin
	update Post set room = room, building = building
	where pseudo = lower(user);
end;
/

-- Permet à l'utilisateur de signaler un post
create or replace procedure add_signal(TARGET_USER in varchar, ID_POST in number) as
begin
	insert into Signal values(TARGET_USER, ID_POST);
end;
/
```
<br>

Un utilisateur signalé un nombre conséquent de fois se voit infligé un bannissement temporaire de l’application.

Au contraire, les utilisateurs avec un nombre d’upvotes total suffisant obtiennent des titres honorifiques en récompense affichés sur leur profils.
[Voir la section sur les vues]()
<br>
De même, un utilisateur peut choisir de “suivre” d’autres utilisateurs ce qui lui permettra de filtrer les posts sur le mur de manière à ne voir que ceux des utilisateurs suivis.
[Voir la section sur les droits]()
<br>
Lors de la rédaction d’un post, il est possible de le sauvegarder en tant que brouillon afin de continuer à le modifier plus tard sans le publier immédiatement.
[Voir la section sur les vues]()
<br>
Cela suppose une certaine sécurité des comptes utilisateurs, qui devront donc s’identifier à l’aide d’un mot de passe secret.
[Voir la section sur les droits]()
<br>

## Posts
Les posts sont des messages textuels publics courts (quelque centaines de caractères au maximum) affichés sur le mur par ordre chronologique décroissant (du plus récent au plus ancien).
<br>
Il est possible de filtrer les messages apparaissant sur le mur en fonction de critères divers (lieu ou heure de publication, auteur de la publication, hashtags impliqués, 
popularité du post, etc.). [Voir la section sur les vues]()
<br>
Il est entendu que les interactions des utilisateurs sur les posts sont la fonctionnalité primordiale de notre application !
<br>
De plus, l’auteur d’un post peut choisir d’y ajouter un sondage.

## Sondages
Un sondage est un questionnaire à choix multiples que l’auteur d’une publication peut choisir d’associer à un post.
<br>
L’auteur devra fournir plusieurs choix possibles et chaque utilisateur pourra choisir un et un seul choix par sondage.
<br>
```SQL
-- PL/SQL

-- Génère un nouvel id de sondage
create or replace function new_idsurvey return number AS
	RESULT number(6);
begin
	select NVL(max(idsurvey)+1, 0) into RESULT
	from Survey;

	return RESULT;
end;
/

-- Génère un nouvel id d'option
create or replace function new_idoption return number AS
	RESULT number(6);
begin
	select NVL(max(idoption)+1, 0) into RESULT
	from Options;

	return RESULT;
end;
/
```
```SQL
-- PL/SQL

-- Procedure pour ajouter un nouveau Survey
create or replace procedure add_survey(QUESTION in varchar, ID_POST in number) as
begin 
    insert into Survey values(new_idsurvey, QUESTION, ID_POST);
end;
/

-- Procedure pour ajouter une nouvelle Option à un Survey
create or replace procedure add_option(CONTENT in varchar, ID_SURVEY in number) as
begin 
    insert into Options values(new_idoption, CONTENT, ID_SURVEY);
end;
/

-- Procedure pour répondre a un Survey
create or replace procedure add_answer(ID_OPTION in number) as
begin
    insert into Answer values(lower(user), ID_OPTION);
end;
/
```

## Hashtags
Un hashtag est un terme spécial employé dans un post qui permet d’en identifier les thèmes.
<br>
Pour insérer un hashtag dans un post, l’utilisateur doit simplement préfixer un terme du caractère ‘#’.
<br>
Les hashtags peuvent servir à déduire les tendances du moment et rassembler les posts abordant un même thème.
```SQL
-- PL/SQL

-- Procedure d'insertion des hashtags extrait d'un post
create or replace procedure add_hashtag(hashtag IN varchar, post IN number) as
	occurences number := 0;
begin
	select
		count(content) into occurences
	from Hashtag where content = hashtag;

	if occurences = 0 then
		insert into Hashtag values (hashtag);
	end if;

	insert into HasHashtag values (post, hashtag);
end;
/

-- Insère tous les mots précédés par un '#' dans la table 
-- Hashtag.
create or replace procedure parse_hashtags(post IN number, msg IN varchar) as
	parser_state number(1) := 0;
	buffer varchar(140) := '';
	c varchar(1) := '_';
begin

	-- Parsing:
	--  - Etat 0: Recherche du caractère '#'
	--	- Etat 1: Récupération du hashtag dans buffer

	if length(msg) > 1 then
		for i in 1..length(msg) loop
			c := substr(msg, i, 1);
			if parser_state = 0 and c = '#' then
				parser_state := 1;
				buffer := '';
			else
				if parser_state = 1 and (c = ' ' or i = length(msg)-1) then
					add_hashtag(buffer, post);
					buffer := '';
					parser_state := 0;
				else
					buffer := buffer || c;
				end if;
			end if;
		end loop;
	end if;

end;
/
```
<br>

## Contraintes d’intégrités

La date d’émission d’un post doit contenir l'horodatage exacte (année, mois, jour, minute, seconde), pour prévenir l’application des robots et codes informatiques tiers.
Un délai de deux secondes sera donc imposé entre la publication de deux posts, si ce délai est outrepassé l’utilisateur sera temporairement banni.
```SQL
-- PL/SQL

-- Renvoie 1 si le dernier post de l'utilisateur actuel date
-- d'au moins deux secondes, 0 sinon.
create or replace function is_post_cooldown_up return boolean as
	max_date date     := current_date;
	delay number      := 0.0;
	post_count number := 0;
begin

	-- S'il n'y a aucun post, il n'y a pas de cooldown.
	select
		count(idpost) into post_count
	from Post;

	if post_count = 0 then
		return TRUE;
	end if;

	select
		max(date_post) into max_date
	from
		Post
	where
		upper(pseudo) = user;

	delay := current_date - max_date;
	-- Conversion en secondes
	delay := delay * 24 * 3600;

	if delay > 2.0 then
		return TRUE;
	else
		return FALSE;
	end if;
end;
/

-- Remarque : cette fonction est utilisée dans la procédure pour créer un nouveau post
```
<br>

Un utilisateur banni ne peut pas interagir avec les autres utilisateurs (posts, upvotes, downvotes, messages privés, sondages).
```SQL
-- PL/SQL

-- Gère les droits de l'utilisateur en fonction de l'état de son banissement
create or replace trigger ban_user after update of ban_end on Users for each row
begin
    if :new.ban_end is null then
        if lower(user) = 'moderator' then
		    execute immediate 'grant client to ' || :new.pseudo;
        end if;
    else
        if current_date < :new.ban_end then
            execute immediate 'revoke client from ' || :new.pseudo;
        else
            execute immediate 'grant client to ' || :new.pseudo;
        end if;
    end if;
end;
/
```
<br>

Un utilisateur ne peut pas se suivre lui-même.
```SQL
alter table Follow add constraint follow_self check (pseudo!=follower);
```
<br>

Un utilisateur peut envoyer un message à un ou plusieurs destinataires (autres utilisateurs), mais ceux-ci le reçoivent de manière séparée.
L’application ne permet donc pas de créer de groupes de messages privés. Cette contrainte est implémenté par la table ```Receive```.
<br>

Un utilisateur ne peut pas envoyer de message privé à lui-même.
```SQL
-- PL/SQL

-- Les utilisateurs ne peuvent pas s'envoyer des messages à eux même
create or replace trigger recipient_self before insert on Receive for each row
declare
    SENDER varchar2(15);
    RECIPIENT number(5);
begin
    select sender into SENDER
    from PrivateMessage
    where idpm = :new.idpm;

    if SENDER = :new.pseudo then
        select count(*) into RECIPIENT
        from Receive
        where idpm = :new.idpm
        group by pseudo;

        if RECIPIENT = 0 then
            delete from PrivateMessage where idpm = :new.idpm;
            RAISE_APPLICATION_ERROR(-20030, '' || :new.pseudo || ' tried to send a private message to himself.');
        end if;
    end if;
end;
/
```
<br>

Les utilisateurs ne peuvent upvoter/downvoter/signaler un post qu’une et une seule fois par compte ! Il en va de même pour les réponses aux sondages.
Cette contrainte est implémentée grâce aux clées primaires des tables ```Vote```, ```Signal``` et ```Answer```.
<br>
	
Un utilisateur ne peut pas upvoter/downvoter/signaler ses propres posts.
```SQL
-- PL/SQL

-- Les utilisateurs ne peuvent voter pour leurs propres posts
create or replace trigger vote_self before insert on Vote for each row
declare
    POST_PSEUDO varchar2(15);
begin
    select pseudo into POST_PSEUDO
    from Post
    where idpost = :new.idpost;
    if :new.pseudo = POST_PSEUDO then
        RAISE_APPLICATION_ERROR(-20030, '' || :new.pseudo || ' tried to vote his own post');
    end if;
end;
/
```
<br>
	
Une adresse mail donnée ne peut être associée qu’à un seul utilisateur, il en va de même pour les pseudonymes.
```SQL
-- PL/SQL

-- Vérifie l'unicité d'un mail
create or replace function mail_unicity(new_mail in varchar) return number as
	result number(1) := 0;
begin
	select count(*) into result
	from Users
	where mail = new_mail;
	if result > 0 then
		return 1;
	else
		return 0;
	end if;
end;
/

-- Procédure ADMIN permettant l'ajout d'un nouveau post
create or replace procedure add_user(pseudo IN varchar, mail IN varchar, password in VARCHAR) as
begin
	if mail_unicity(mail) = 0 then
		insert into Users values (pseudo, null, null, mail, 'unknown', null, null, null);
		execute immediate 'create user ' || pseudo || ' identified by ' || password;
		execute immediate 'grant client to ' || pseudo;
	else
		RAISE_APPLICATION_ERROR(-20589, 'The adress mail : ' || mail || ' is already used.');
	end if;
end;
/
```
<br>

Un brouillon validé est supprimé le plus tôt possible et un post équivalent est généré.
```SQL
-- PL/SQL

-- Un draft est posté, puis supprimé
create or replace trigger post_draft after update of state on Draft for each row
begin
    if :new.state = TRUE then
        add_post(:new.message, null, null);
        delete from Draft where iddraft = :new.iddraft;
    else
        delete from Draft where iddraft = :new.iddraft;
    end if; 
end;
/

-- Permet à l'utilisateur de modifier l'attribut validate de l'un de ses brouillons (draft)
create or replace procedure validate_draft(id in number, state in boolean) as
begin
	update Draft set state = state where iddraft = id;
end;
/
```
<br>

Un post inséré doit avoir la date correspondant au moment où il est posté.
Cette contrainte d'intégrité est implémenté dans la procedure ```add_post(msg IN varchar, room IN varchar, building IN varchar)```.

Un mot contenu dans un post et préfixé par ‘#’ est ajouté à la liste des hashtags s’il n’y est pas déjà.
```SQL
-- PL/SQL

-- Insertion automatique des hashtags d'un post
create or replace trigger extract_hashtags after insert on Post for each row
begin
    admin.parse_hashtags(:new.idpost, :new.message);
end;
/
```
<br>

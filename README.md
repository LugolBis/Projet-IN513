# Projet - IN513

## Contributeurs
- [@LugolBis - Loïc DESMARES](https://github.com/LugolBis)
- [@Sama GHARIB ALI BARURA](https://github.com/sama-gharib)

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
[Voir la section sur les vues](https://github.com/uvsq22201674/Projet-IN513/blob/main/README.md#vues)
<br>
De même, un utilisateur peut choisir de “suivre” d’autres utilisateurs ce qui lui permettra de filtrer les posts sur le mur de manière à ne voir que ceux des utilisateurs suivis.
[Voir la section sur les droits](https://github.com/uvsq22201674/Projet-IN513/blob/main/README.md#droits)
<br>
Lors de la rédaction d’un post, il est possible de le sauvegarder en tant que brouillon afin de continuer à le modifier plus tard sans le publier immédiatement.
[Voir la section sur les vues](https://github.com/uvsq22201674/Projet-IN513/blob/main/README.md#vues)
<br>
Cela suppose une certaine sécurité des comptes utilisateurs, qui devront donc s’identifier à l’aide d’un mot de passe secret.
[Voir la section sur les droits](https://github.com/uvsq22201674/Projet-IN513/blob/main/README.md#droits)
<br>

## Posts
Les posts sont des messages textuels publics courts (quelque centaines de caractères au maximum) affichés sur le mur par ordre chronologique décroissant (du plus récent au plus ancien).
<br>
Il est possible de filtrer les messages apparaissant sur le mur en fonction de critères divers (lieu ou heure de publication, auteur de la publication, hashtags impliqués, 
popularité du post, etc.). [Voir la section sur les vues](https://github.com/uvsq22201674/Projet-IN513/blob/main/README.md#vues)
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

## Droits

On suppose que toutes les intéractions non permises explicitement sont interdites ! Un réseau social est un système dynamique et dangereux qui se doit de modérer vigoureusement les données qu’on lui soumet.

### Role : client
Création du rôle :
```SQL
create role client;
grant create session to client;
grant create view to client;
```
<br>

Les comptes utilisateurs ont le droit d’ajouter et de visualiser des posts et des sondages, d’upvoter/downvoter des posts, de répondre à des sondages et d’enregistrer et de lire leurs brouillons.
```SQL
grant select, insert on Post to client, moderator;
grant select, insert on Survey to client, moderator;
grant select, insert on Options to client, moderator;
grant select, insert on Follow to client, moderator;
grant select, insert on Vote to client, moderator;
grant select, insert on Hashtag to client, moderator;
grant select, insert on HasHashtag to client, moderator;
grant select, insert on Signal to client, moderator;
```
<br>

Ils ont également accès au nombre de signalements des posts/sondages et peuvent le modifier dans le respect des contraintes d’intégrités. Évidemment, chaque utilisateur peut accéder à ses informations personnelles, mais pas à celles des autres utilisateurs ! Bien sûr, il est également permis aux utilisateurs de lire leurs messages reçus et envoyés et d’accéder aux données des hashtags. En outre, chaque utilisateur peut accéder aux données non-sensibles des autres utilisateurs comme le pseudonyme, le nombre de followers, les comptes suivis, etc. Un utilisateur n’ayant pas voté à un sondage n'aura pas accès à ses résultats.
<br>

Droits d'exécutions de procédures pour les utilisateurs :
- [Activities](https://github.com/uvsq22201674/Projet-IN513/blob/main/requests/client/activities.sql)

	```SQL
 	grant execute on is_post_cooldown_up to client, moderator;
	grant execute on add_hashtag to client, moderator;
	grant execute on parse_hashtags to client, moderator;
	grant execute on new_idpost to client, moderator;
	grant execute on new_idsurvey to client, moderator;
	grant execute on new_idoption to client, moderator;
	grant execute on update_location to client, moderator;
	grant execute on add_post to client, moderator;
	grant execute on validate_draft to client, moderator;
	grant execute on add_vote to client, moderator;
 	```
 
- [Hashtags](https://github.com/uvsq22201674/Projet-IN513/blob/main/requests/client/hashtag.sql)

	```SQL
 	grant execute on get_proportion_hashtag to client, moderator;
	grant execute on max_frequency_hashtag to client, moderator;
	grant execute on get_hashtag_day to client, moderator;
 	```
 
- [Message thread](https://github.com/uvsq22201674/Projet-IN513/blob/main/requests/client/message_thread.sql) (Messages privés)

	```SQL
 	grant execute on get_proportion_message to client, moderator;
	grant execute on new_id_private_message to client, moderator;
	grant execute on send_message to client, moderator;
 	```
 
- [Survey](https://github.com/uvsq22201674/Projet-IN513/blob/main/requests/client/survey.sql) (Sondages)

	```SQL
 	grant execute on add_survey to client, moderator;
	grant execute on add_option to client, moderator;
	grant execute on add_answer to client, moderator;
	grant execute on survey_result to client, moderator;
 	```

- [Utilisateurs](https://github.com/uvsq22201674/Projet-IN513/blob/main/requests/client/users.sql)

	```SQL
 	grant execute on get_average_rank_post to client, moderator;
	grant execute on get_linked_user to client, moderator;
 	```

- [Views - Grades](https://github.com/uvsq22201674/Projet-IN513/blob/main/views/grades.sql)

	```SQL
 	grant execute on get_user_count to client, moderator;
 	grant select on Goat to client, moderator;
 	grant select on Influencer to client, moderator;
 	grant select on Nobody to client, moderator;
 	```

### Role : moderator
Création du rôle :
```SQL
create role moderator;
grant create session to moderator;
grant create view to moderator;
```
<br>

Le compte modérateur a tous les droits des utilisateurs ainsi que les droits de supprimer des posts/sondages, de bannir temporairement ou de supprimer définitivement des utilisateurs.
```SQL
grant execute on admin.add_user to moderator;
grant delete on Post to moderator;
grant delete on Survey to moderator;
grant update (date_end, ban_reason) on Users to moderator;
```
<br>

Il doit être en capacité de lire les adresses IP et mails des utilisateurs pour pouvoir veiller au mieux à empêcher l’utilisation de plusieurs comptes par une même personne visant à fausser les votes. Néanmoins il n’a absolument pas l’autorité de modifier ces deux données.
```SQL
-- PL/SQL

-- Fonction permettant de récupérer l'adresse IP d'un utilisateur
create or replace function get_IPadress(TARGET_USER in varchar2)
return varchar2 as
    RESULT varchar2(15) := '';
begin
    select IPaddress into RESULT
    from Users
    where pseudo = TARGET_USER;

    return RESULT;
end;
/

-- Fonction permettant de récupérer l'adresse mail d'un utilisateur
create or replace function get_Mail(TARGET_USER in varchar2)
return varchar2 as
    RESULT varchar2(64) := '';
begin
    select mail into RESULT
    from Users
    where pseudo = TARGET_USER;

    return RESULT;
end;
/
```
```SQL
grant execute on get_IPadress to moderator;
grant execute on get_Mail to moderator;
```
<br>

### Utilisateur : admin
L'utilisateur ```admin``` est utilisé pour déployer et administrer la base de données. Étant donné que c'est l'```admin``` qui crée la BDD les tables et procédures lui sont liés.

Création de l'utilisateur :
```SQL
create user admin identified by banane;
grant create session to admin;
grant unlimited tablespace to admin;
grant create table to admin;
grant create procedure to admin;
grant create user to admin;
grant create trigger to admin;
grant create view to admin;
grant grant any role to admin;
```
<br>

## Vues

Il existe quatre vues correspondant aux quatre rangs d’utilisateurs, définit par leurs votes :
1. Goat        : 1% des meilleurs utilisateurs
2. Influenceur : 1-50% des meilleurs utilisateurs
3. Nobody      : 50% des meilleurs utilisateurs

```SQL
-- PL/SQL

-- Fonction permettant de calculer le nombre d'utilisateurs total
create or replace function get_user_count return number as
	n number := 0;
begin
	select
		count(pseudo) into n
	from
		Rank;

	return n;
end;
/
```
```SQL
-- Vue Goat
create or replace view Goat as select
	pseudo, rank
from
	Rank
where
	rownum <= 0.1 * get_user_count;

-- Vue Influencer
create or replace view Influencer as select
	pseudo, rank
from
	Rank
where
	rownum > 0.1 * get_user_count and
	rownum <= 0.5 * get_user_count;

-- Vue Nobody
create or replace view Nobody as select
	pseudo, rank
from
	Rank
where
	rownum > 0.5 * get_user_count;
```
<br>

On note également la vue Tendance des 10 hashtags les plus utilisés dans les sept jours précédents.
```SQL
create or replace view Tendance as
select HH.hashtag as hashtag, count(HH.idpost) as nb_posts
from HasHashtag HH, Post P
where P.idpost=HH.idpost and P.date_post>=(SYSDATE-7)
group by HH.hashtag
order by nb_posts desc 
fetch first 10 rows only;

grant select on Tendance to client, moderator;
```
<br>

La vue MyMessage quant à elle se charge de contenir tous les messages (reçus et envoyés)  ainsi que leur date d’envoie pour chaque utilisateur.
```SQL
create or replace view MyMessages as select
	pm.sender as sender, r.pseudo as recipient, pm.message as message,
	pm.date_send as date_send
from
	PrivateMessage pm, Receive r
where
	pm.idpm = r.idpm and
	(pm.sender = lower(user) or r.pseudo = lower(user));

grant select, update, delete on MyMessages to client, moderator;
```
<br>

La vue Sanctions qui permet d’obtenir la liste des utilisateurs bannis ainsi que la durée restante de leur bannissement.
```SQL
create or replace view Sanctions as
select pseudo, ban_end - SYSDATE as time_left, ban_reason
from Users
where SYSDATE < ban_end;

grant select on Sanctions to client, moderator;
```
<br>

La vue Rank qui permet d’obtenir le classement de tous les utilisateurs.
```SQL
create or replace view Rank as
select Post.pseudo as pseudo, sum(Vote.value) as rank
from Post, Vote
where Post.idpost = Vote.idpost
group by Post.idpost, Post.pseudo
order by rank desc;

grant select on Rank to client, moderator;
```
<br>

La vue TopUser qui permet d’obtenir les utilisateurs les plus suivis.
```SQL
create or replace view TopUser as
select Users.pseudo, count(*) as nb_followers
from Users left join Follow on Users.pseudo=Follow.pseudo
group by Users.pseudo
order by nb_followers desc;

grant select on TopUser to client, moderator;
```
<br>

La vue Feed qui permet d’obtenir tous les posts des utilisateurs que l’on suit.
```SQL
create or replace view Feed as
select * from Post
where pseudo in (select pseudo from Follow where follower=lower(user))
order by date_post desc;

grant select on Feed to client, moderator;
```
<br>

La vue RankPost qui contient le rank (somme des upvotes et des downvotes), le nombre d’upvotes et le nombre de downvotes d’un post.
```SQL
create or replace view RankPost as
select sum(value) as rank,
   sum(case when Vote.value > 0 then 0 else 1 end) as downvotes,
   sum(case when Vote.value > 0 then 1 else 0 end) as upvotes
from Vote
group by idpost;

grant select on RankPost to client, moderator;
```
<br>

La vue MyDraft qui contient tous les brouillons d’un utilisateur donné.
```SQL
create or replace view MyDraft as
select * 
from Draft 
where pseudo = lower(user)
order by iddraft desc;

grant select, update, delete on MyDraft to client, moderator;
```
<br>

La vue UrgentSignal qui contient tous les posts les plus signalés.
```SQL
create or replace view UrgentSignal as
select idpost
from Signal
group by idpost
having count(*) >= 30;

grant select on UrgentSignal to moderator;
```
<br>

## Déploiement de la BDD

### Requirements
| Database system | Compatibility |
|:-:|:-:|
| Oracle Database 23ai | ✅ |

### Installation
Ce repository contient tous les scripts nécessaire à la création de notre base de donnée.
Le fichier [***build_database.sql***](https://github.com/uvsq22201674/Projet-IN513/blob/main/build_database.sql) référence tous les scripts dans l'ordre d'appel. Pour construire la base de donnée il faut
executer les commandes suivantes :
```bash
$ cd /chemin/vers/la/repo/Projet-IN513/
$ sqlplus
```
Entrez les identifiants administrateurs de la BDD.
```sqlplus
SQL > @users/create_users.sql
SQL > exit
```
```bash
$ sqlplus admin/banane
```
```sqlplus
SQL > @build_database.sql
```

## Peuplement de la BDD

### Génération de données
Pour peupler la base de données nous avons eu recourt à un model d'IA : Chat-GPT4. Si vous souhaitez plus d'informations sur la partie *Prompt engineering* consultez le fichier suivant [Détails des prompts](https://github.com/uvsq22201674/Projet-IN513/blob/main/RENDU/prompts.txt).

### Chargement massif de données - SQL*LOADER
Afin de charger rapidement les données générées et formatées (en .csv), nous avons utilisé SQL*Load. Si vous souhaitez plus amples détails vous pouvez vous référer au dossier suivant : [SQL*LOAD](https://github.com/uvsq22201674/Projet-IN513/tree/main/populate/sqlload).

## Méta données de la BDD

Liste des contraintes d'intégritées de la BDD :
```SQL
select 
uc.table_name,
uc.constraint_name,
uc.constraint_type,
ucc.column_name,
ucc.position,
uc.search_condition as constraint_body
from user_constraints uc left join user_cons_columns ucc
on uc.constraint_name = ucc.constraint_name and uc.table_name = ucc.table_name
where uc.table_name in ('USERS', 'POST', 'SURVEY', 'OPTIONS', 'PRIVATEMESSAGE', 'RECEIVE', 'FOLLOW', 'DRAFT', 'VOTE', 'SIGNAL', 'ANSWER', 'HASHTAG', 'HASHASHTAG')
order by uc.table_name, uc.constraint_type, uc.constraint_name;
```
<br>

Liste des triggers de la BDD :
```SQL
select
table_name,
trigger_name,
triggering_event,
trigger_type,
status,
description
from user_triggers
order by table_name, trigger_name;
```
<br>

Liste de tous les utilisateurs :
```SQL
select username
from all_users
where username not in (
    'SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'MGMT_VIEW', 'APPQOSSYS',
    'AUDSYS', 'CTXSYS', 'DVSYS', 'FLOWS_FILES', 'MDDATA', 'MDSYS',
    'ORDDATA', 'ORDSYS', 'XDB', 'WMSYS', 'LBACSYS', 'OLAPSYS',
    'OWBSYS', 'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR',
    'SI_INFORMTN_SCHEMA', 'ANONYMOUS', 'APEX_PUBLIC_USER', 'VECSYS',
    'APEX_040000', 'APEX_050000', 'DIP', 'GSMADMIN_INTERNAL',
    'GSMCATUSER', 'GSMUSER', 'REMOTE_SCHEDULER_AGENT', 'SYSRAC',
    'XS$NULL', 'OJVMSYS', 'DBSFWUSER', 'DGPDB_INT', 'DVF', 'GGSHAREDCAP',
    'GGSYS', 'GSMROOTUSER', 'SYSBACKUP', 'SYSDG', 'SYSKM', 'SYS$UMF'
)
order by username;
```
<br>

## Requêtes d'exemple sur la BDD

1. Quelle est la liste des hashtags utilisés par [pseudo] ?
	```SQL
	select distinct HH.hashtag
	from admin.HasHashtag HH, admin.Post P
	where HH.idpost = P.idpost
	and P.pseudo = 'lulu';
	```
2. Quelle est la moyenne des votes des posts de [pseudo] ?
	```SQL
 	-- PL/SQL
   
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
	```
3. Est-ce que [pseudo] est suivi par au moins un des utilisateurs que je suis ?
	```SQL
 	-- PL/SQL
 
 	create or replace function get_linked_user(TARGET_USER in varchar2)
	return boolean as
	    RESULT number(6);
	begin
	    select count(*) into RESULT
	    from admin.Follow F1, admin.Follow F2
	    where F1.follower = F2.pseudo
	    and F1.pseudo = TARGET_USER
	    and F2.follower = lower(user);
	
	    return RESULT > 0;
	end;
	/
	```
4. Quels sont les utilisateurs que je suis et qui me suivent ?
	```SQL
 	SELECT F1.follower AS mutual_follow
	FROM admin.Follow F1, admin.Follow F2
	WHERE F1.follower = F2.pseudo
	AND F1.pseudo = lower(user) AND F2.follower = lower(user);
 	```
5. Quels sont les utilisateurs qui suivent [pseudo] ET qui sont suivis par [pseudo] ?
	```SQL
 	SELECT F1.follower AS mutual_follow
	FROM admin.Follow F1
	JOIN admin.Follow F2 ON F1.follower = F2.pseudo
	WHERE F1.pseudo = 'jojo' AND F2.follower = 'lulu';
 	```
6. Quels sont les utilisateurs que je suis mais qui ne me suivent pas ?
	```SQL
 	SELECT F1.follower AS not_following_back
	FROM admin.Follow F1
	LEFT JOIN admin.Follow F2 ON F1.follower = F2.pseudo AND F2.follower = lower(user)
	WHERE F1.pseudo = lower(user) AND F2.pseudo IS NULL;
 	```
7. Quel est l'utilisateur qui approuve/désapprouve le plus de mes posts ?
	```SQL
 	select V.pseudo, sum(V.value) as upvotes
	from admin.Vote V, admin.Post P
	where V.idpost = P.idpost
	and V.value > 0 and P.pseudo = lower(user)
	group by V.pseudo
	having upvotes > 0
	order by upvotes desc;
	
	select V.pseudo, sum(V.value) as downvotes
	from admin.Vote V, admin.Post P
	where V.idpost = P.idpost
	and V.value < 0 and P.pseudo = lower(user)
	group by V.pseudo
	having downvotes > 0
	order by downvotes desc;
 	```
8. Quels sont les récents posts de [pseudo] ?
	```SQL
	select *
	from admin.Post
	where pseudo = 'lulu'
	order by date_post desc;
 	```
9. Quels sont les posts émis depuis [building et/ou room] ?
	```SQL
	select *
	from admin.Post
	where building = 'Fermat'
	and room = 'Amphi J'
	order by date_post desc;
 	```
10. Quels sont les posts postés entre [date_debut] et [date_fin] ?
	```SQL
	select *
	from admin.Post
	where date_post between date '2012-08-30' and date '2012-10-11'
	order by date_post desc;
 	```
11. Quels sont les [n] posts les plus récents ?
	```SQL
 	select *
	from admin.Post
	order by date_post desc
	fetch first 15 rows only;
 	```
12. Quels sont les posts contenant [mot(s)] ?
	```SQL
 	select *
	from admin.Post
	where REGEXP_LIKE(message, 'Banane', 'i') = TRUE
	order by date_post desc;
 	```
13. Quels sont les posts utilisant le hashtag [#hashtag] ?
	```SQL
 	select *
	from admin.Post
	where idpost in (
	    select idpost 
	    from admin.HasHashtag
	    where hashtag= 'genant')
	order by date_post desc;
 	```
14. Quels sont les posts les plus upvotés/downvotés ?
	```SQL
 	select P.idpost, P.message, P.date_post, P.room, P.building, P.pseudo, NVL(V.rank, 0) as rank
	from admin.Post P
	left join (
	    select V.idpost, count(V.pseudo) as rank
	    from admin.Vote V
	    where V.value = 1
	    group by V.idpost
	) V
	on P.idpost = V.idpost
	order by rank desc;
 	```
15. Quels utilisateurs ont utilisé les hashtags en tendance ? (Quel est l’intervalle temporel de cette requête ?)
	```SQL
 	select pseudo
	from admin.Post 
	where date_post >= SYSDATE-7
	and idpost in (
	    select idpost
	    from admin.HasHashtag
	    where hashtag in (
	        select hashtag
	        from admin.Tendance
	    )
	)
	order by date_post desc;
 	```
16. Quelle est la proportion de hashtags tendance/non tendance utilisés par un utilisateur ?
	```SQL
 	-- PL/SQL
 
 	create or replace function get_proportion_hashtag(TARGET_USER in varchar2) return number as
	    total_hashtags number(6);
	    total_tendance number(6);
	begin
	    select count(*) into total_hashtags
	    from admin.Post
	    where date_post >= SYSDATE-7
	    and pseudo = TARGET_USER
	    and idpost in (
	        select idpost
	        from admin.HasHashtag
	    );
	
	
	    select count(*) into total_tendance
	    from admin.Post
	    where date_post >= SYSDATE-7
	    and pseudo = TARGET_USER
	    and idpost in (
	        select idpost
	        from admin.HasHashtag
	        where hashtag in (
	            select hashtag
	            from admin.Tendance
	        )
	    );
	
	    if total_hashtags < 1 then
	        return 0;
	    else
	        return (total_tendance*100)/total_hashtags;
	    end if;
	end;
	/
 	```
17. Quel sont les hashtags les plus fréquemment postés avec le hashtag [a] ?
	```SQL
 	-- PL/SQL
 
 	create or replace function max_frequency_hashtag(HT in varchar)
	return number as
	    RESULT number(6);
	begin
	    select count(*) into RESULT
	    from admin.HasHashtag h1, admin.HasHashtag h2
	    where h1.idpost = h2.idpost
	    and h1.hashtag = HT
	    and h2.hashtag != HT
	    group by h2.hashtag;
	
	    return RESULT;
	end;
	/

	select h2.hashtag, count(*) as occurence
	from admin.HasHashtag h1, admin.HasHashtag h2
	where h1.idpost = h2.idpost
	and h1.hashtag = 'genant'
	and h2.hashtag != 'genant'
	group by h2.hashtag
	having occurence = admin.max_frequency_hashtag('genant')
	order by occurence desc;
	```
18. Quel est le jour durant lequel un hashtag [a] a été le plus posté ?
	```SQL
 	-- PL/SQL
 
	create or replace function get_hashtag_day(HASHTAG in varchar2) return date as
	    DATE_RESULT date := SYSDATE;
	begin
	    select trunc(P.date_post) into DATE_RESULT
	    from admin.Post P, admin.HasHashtag HH
	    where HH.idpost = P.idpost and HH.hashtag = HASHTAG
	    group by trunc(P.date_post)
	    order by count(*) desc
	    fetch first 1 rows only;
	
	    return DATE_RESULT;
	end;
	/
 	```
19. Quels sont les sondages contenant [mot(s)] dans sa question ?
	```SQL
	select *
	from admin.Survey
	where REGEXP_LIKE(question, 'genant', 'i') = TRUE;
 	```
20. Quels sont les sondages contenant [mot(s)] dans ses options ?
	```SQL
 	select *
	from admin.Survey
	where idsurvey in (
	    select idsurvey
	    from admin.Options
	    where REGEXP_LIKE(content, 'banane', 'i') = TRUE
	);
	```
21. Quel est le pourcentage d'utilisateurs ayant choisi cette [option] à cette [question] ?
	```SQL
 	-- PL/SQL
 
	create or replace function survey_result(TARGET_OPTION in varchar2, TARGET_SURVEY in number)
	return number as
	    VOTED number(3);
	    TOTAL_VOTERS number(7);
	begin
	    select count(*) into VOTED
	    from Options O, Survey S
	    where O.idsurvey = S.idsurvey
	    and O.content = TARGET_OPTION
	    and S.idsurvey = TARGET_SURVEY
	    group by O.idoption;
	
	    select count(*) into TOTAL_VOTERS
	    from Options O, Survey S
	    where O.idsurvey = S.idsurvey
	    and S.idsurvey = TARGET_SURVEY;
	
	    return VOTED/TOTAL_VOTERS;
	end;
	/
	```
22. Quels sont les sondages comptabilisant le plus de votants ?
	```SQL
 	select S.idsurvey, S.question, S.idpost, NVL(RES.rank, 0) as rank 
	from admin.Survey S
	left join (
	    select O.idsurvey as id, count(*) as rank
	    from admin.Answer A 
	    left join admin.Options O on A.idoption = O.idoption
	    group by O.idsurvey
	) RES
	on S.idsurvey = RES.id
	order by rank desc;
 	```
23. Quels sont les sondages contenant [n] options ?
	```SQL
	select *
	from admin.Survey
	where idsurvey in (
	    select idsurvey
	    from admin.Options
	    group by idsurvey
	    having count(distinct idoption) = 2
	);
 	```
24. Quel est le brouillon le plus récent que j'ai rédigé ?
	```SQL
	select message
	from admin.MyDraft
	fetch first 1 rows only;
 	```
25. Quel est le plus long brouillon que j’ai rédigé ?
	```SQL
 	select message
	from admin.MyDraft
	where length(message) = (select max(length(message)) from admin.MyDraft);
 	```
26. Quelles sont mes dernières discussions privées ?
	```SQL
	select distinct pseudo
	from(
		select a.pseudo as pseudo, a.date_send
		from (
			select recipient as pseudo, date_send
			from admin.MyMessages
			where sender = lower(user)
			union
			select sender as pseudo, date_send
			from admin.MyMessages
			where recipient = lower(user)
		) a
		order by a.date_send
	);
 	```
27. Quelle est la proportion de messages envoyés/messages reçus de l’utilisateur A à l’utilisateur B ?
	```SQL
 	-- PL/SQL
 
	create or replace function get_proportion_message(TARGET_USER in varchar2)
	return number as
	    total_messages number(6);
	    total_send number(6);
	begin
	    select count(*) into total_messages
	    from Receive R, PrivateMessage PM
	    where R.idpm = PM.idpm
	    and (
	        (R.pseudo = lower(user) and PM.sender = TARGET_USER)
	        or (R.pseudo = TARGET_USER and PM.sender = lower(user))
	    )
	    group by R.idpm;
	
	    select count(*) into total_send
	    from Receive R, PrivateMessage PM
	    where R.idpm = PM.idpm
	    and R.pseudo = TARGET_USER and PM.sender = lower(user)
	    group by R.idpm;
	
	    if total_messages < 1 then
	        return 0;
	    else
	        return (total_send*100)/total_messages;
	    end if;
	end;
	/
 	```
28. Quels sont les utilisateurs qui ont voté pour tous les posts ?
	```SQL
 	select pseudo
	from admin.Vote
	group by pseudo
	having count(idpost) = (select count(*) from admin.Post);
 	```

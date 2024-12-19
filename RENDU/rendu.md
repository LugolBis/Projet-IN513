# Rendu phase 2 IN513

DESMARRES Loïc
GHARIB ALI BARURA Sama
BERRHAMAN Aissam

## A/ Création du schéma de la base de données
### vote.sql
```
-- Création de la table
create table Vote(
    pseudo varchar(15),
    idpost number(6),
    value Number(1) not null,
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idpost) references Post(idpost) on delete cascade
);
```
### user.sql
```
-- Création de la table
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
```
### survey.sql
```
-- Création de la table
create table Survey(
    idsurvey Number(6) primary key,
    question varchar(280) not null,
    idpost number(6),
    foreign key (idpost) references Post(idpost) on delete cascade
);
```
### signal.sql
```
-- Création de la table
create table Signal(
    pseudo varchar(15),
    idpost number(6),
    primary key (pseudo, idpost),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idpost) references Post(idpost) on delete cascade
);
```
### receive.sql
```
-- Création de la table
create table Receive(
    idpm Number(6),
    pseudo varchar(15),
    primary key (idpm, pseudo),
    foreign key (pseudo) references Users(pseudo) on delete cascade
);
```
### private_message.sql
```
-- Création de la table
create table PrivateMessage(
    idpm Number(6) primary key,
    message varchar(280) not null,
    date_send date not null,
    sender varchar(15),
    foreign key (sender) references Users(pseudo) on delete cascade
);
```
### post.sql
```
-- Création de la table
create table Post (
    idpost number(6) primary key,
    message varchar(280) not null,
    date_post date not null,
    room varchar(20),
    building varchar(20),
    pseudo varchar(15),
    foreign key (pseudo) references Users(pseudo) on delete cascade
);
```
### option.sql
```
-- Création de la table
create table Options(
    idoption Number(6) primary key,
    content varchar(150) not null,
    idsurvey Number(6),
    foreign key (idsurvey) references Survey(idsurvey) on delete cascade
);
```
### hashtag.sql
```
-- Création de la table
create table Hashtag(
    content varchar(140) primary key
);
```
### has_hashtag.sql
```
-- Création de la table
create table HasHashtag(
    idpost number(6),
    hashtag varchar(140),
    primary key (idpost, hashtag),
    foreign key (idpost) references Post(idpost) on delete cascade,
    foreign key (hashtag) references Hashtag(content) on delete cascade
);
```
### follow.sql
```
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
```
### draft.sql
```
-- Création de la table
create table Draft(
    iddraft Number(5) primary key,
    message varchar(280),
    pseudo varchar(15),
    state boolean,
    foreign key (pseudo) references Users(pseudo) on delete cascade
);
```
### answer.sql
```
-- Création de la table
create table Answer(
    pseudo varchar(15),
    idoption Number(6),
    primary key (pseudo, idoption),
    foreign key (pseudo) references Users(pseudo) on delete cascade,
    foreign key (idoption) references Options(idoption) on delete cascade
);
```

## B/ Jeu de données
### prompts.txt
```
Prompt n°1 :
Mémorise l'implémentation des tables en SQL ci joint dans le script. Si tu as correctement mémorisé réponds moi "Ok !".
*Joindre un script contenant la création des tables*

Prompt n°2 :
Mémorise l'implémentation des triggers de la BDD ci joint dans le script. Si tu as correctement mémorisé réponds moi "Ok !".
*Joindre l'implémentation des triggers*

Prompt n°3 :
Mémorise l'implémentation des droits des divers utilisateurs accédant à la BDD ci joint dans le script. Si tu as correctement mémorisé réponds moi "Ok !".
*Joindre l'implémentation des droits*

Prompt n°4 :
Mémorise l'implémentation des vues de la BDD ci joint dans le script. Si tu as correctement mémorisé réponds moi "Ok !".
*Joindre l'implémentation des vues*

Prompt n°5 :
Génère 40 tuples pours la table Users, les éléments textuels sont générés aléatoirement et doivent ressembler a de vraies données.
Parmis les 40 tuples une dizaine d'entre eux auront les champs ban_end et ban_reason remplis. Parmis les 40 tuples 25 d'entres eux auront une description. N'oublie pas de générer les données au format CSV.
Serais tu capable de généré un pseudo de manière aléatoire en mélangeant les lettres des champs surname et name et en ajoutant éventuellement le symbol "_" ou des chiffres, pour les 40 utilisateurs ?
Je ne veux pas que les utilisateurs aient tous le même nom basique "user". Par exemple un utilisateur pourrait s'appeller "lulu" ou encore "FoudreDeGuerre", etc.
De plus modifie les description pour y ajouter quelques descriptions en Anglais et en Français.

Prompt n°6 :
Génère moi le contenu de la table Post au format CSV. je veux que tu génère 40 tuples, le champ idpost indiquera simplement le numéro de n ième tuple à être généré.
Le message doit être une chaine de caractère comme les descriptions, mets des langues variées (Français, Espagnols, Anglais, Allemand, Italien), chacun d'entre eux doit être différent.
Chaque message doit constituer une phrase cohérente. Parmis les 40 tuples, 25 d'entre eux auront 1 à 7 hashtags dans leur message (Un hashtag correspond au symbole '#' suivit d'un mot et d'un espace).
Le champs date_post sera rempli avec une date au format "AAAA-MM-DD" (met bien les tirets et ce doit être une chaîne de caractères). Parmis les 40 tuples, 25 d'entres eux contiendrons soit l'indication du champs 'room', soit l'indication du champs 'building' ou les deux.
Enfin le champs pseudo soit impérativement correspondre à un pseudo que tu viens de généré pour la table Users.

Prompt n°7 :
Génère 35 tuples pour la table Survey. Pour le champs idsurvey fait comme avec le champs idpost de la table Post.
Pour le champs question tu dois générer de manière aléatoire 35 questions en anglais complètement différentes les une des autres.
Pour le champs idpost récupère un idpost de la table Post de manière aléatoire et sans remise (je ne veux pas que plusieurs tuples aient le même idpost).

Prompt n°8 :
Génère 45 tuples pour la table Options tu va te baser sur la table Survey.
Pour chaque tuple de la table survey tu vas générer entre 2 et 5 réponses cohérentes en fonction de la question posée dans chaque tuple de la table Survey
(Pour chaque tuple de la table Survey tu génère 2 à 5 tuples options dont l'idoption est juste un banal compteur comme idpost, le champs content lui doit répondre à la question du tuple auquel il se réfère avec idsurvey).

Prompt n°9 :
Génère 80 tuples pour la table PrivateMessage. Sachant que idpm est un compteur comme idpost, message doit être une phrase cohérente (comme un post mais sans Hashtags).
Les champs dates et sender doivent être cohérent de manière a simuler une véritable discussion.
Exemple : "lulu" envoie : "Je t'aimes." à "juju" et "juju" lui REPOND "Moi aussi !", la date du tuple contenant le message de "lulu" doit être antérieure à celle du tuple du message de "juju", car celle ci lui REPOND.
Un peu comme toi et mois qui avons une conversation, ce message que j'écris aura une date antérieur à ta réponse. N'oublie pas que le champs "sender" correspond au pseudo d'un utilisateur présent dans la table Users. Enfin je voudrai que 10 utilisateurs soient absent de la table.

Prompt n°10 :
Génère maintenant 80 tuples pour la table Receive qui simule qui à reçu chaque PrivateMessage, essaie de garder les discussion les plus cohérentes possible.

Prompt n°11 :
Peuple la table Follow avec 80 tuples de telle sorte que les champs pseudo et follower soient toujours différent et qu'ils soient tous deux des pseudo de la table Users.

Prompt n°12 :
Génère 35 tuples pour la table Draft. Le champs iddraft est fonctionne comme le champs idpost, le message doit être une phrase et le pseudo soit être inclut dans la table Users.

Prompt n°13 :
Génère 80 tuples pour la table Vote. Sachant que pseudo est un pseudo de la table Users, idpost doit être compris dans la table Post et value prend soit la valeur "-1" ou la valeur "1". De plus 15 tuples de la table Post  seront absent de la table Vote.

Prompt n°14 :
Génère 40 tuples pour la table Signal. Parmis ceux ci 31 tuples auront la même valeur de idpost. Fais en sorte que tous les pseudo soient unique.

Prompt n°15 :
Génère 80 tuples pour la table Answer (fait bien attention à ce que les clées étrangère existent dans leur tables respectives).

Informations supplémentaires :
- Modèle utilisé : Chat-GPT4o
- Les données générés ont été retravaillées pour répondre aux enjeux des contraintes d'intégrité de la BDD et d'Oracle.
  Pour retravailler les données nous avons utilisé Chat-GPT et Python.

Répartition finale des tuples de chaque table :

Users : 40
Quelques exemples :
quirfy29,John,Doe,john.doe@example.com,192.168.1.1,"Utilisateur actif sur le réseau social.",2024-12-15,"Violation of guidelines"
smithjane,Jane,Smith,jane.smith@example.com,192.168.1.2,"Explorateur de hashtags tendance.",,
mikej09,Mike,Johnson,mike.johnson@example.com,192.168.1.3,"Enjoying my time on this platform!",,

Post : 40
Quelques exemples :
1,"The quick brown fox jumps over the lazy dog. #adventure #nature",2024-03-15,,,"quirfy29"
2,"Un petit pas pour l homme, un grand pas pour l humanite. #espace",2024-07-22,,,"smithjane"
3,"Caminante, no hay camino, se hace camino al andar. #cultura",2024-01-19,"RoomA","BuildingX","mikej09"

Survey : 35
Quelques exemples :
1,"What is the best way to improve communication skills?",1
2,"How do you define success in your own life?",2
3,"What motivates you to wake up every morning?",3

Options : 55
Quelques exemples :
1,"Spend more time communicating with others.",1
2,"Practice active listening daily.",1
3,"Set clear goals for personal achievements.",2

PrivateMessage : 80
Quelques exemples :
1,"I hope you are having a wonderful day.",2023-12-01 09:15:32,quirfy29
2,"Thank you! I am doing well. How about you?",2023-12-01 09:30:45,smithjane
3,"Did you see the latest updates on the project?",2023-12-02 11:05:12,mikej09

Receive : 80
Quelques exemples :
1,smithjane
2,quirfy29
3,lindawil

Follow : 79
Quelques exemples :
quirfy29,smithjane
mikej09,lindawil
brown_55,susie88

Draft : 35
Quelques exemples :
1,"The quick brown fox jumps over the lazy dog.",quirfy29
2,"A journey of a thousand miles begins with a single step.",smithjane
3,"Life is what happens when you're busy making other plans.",mikej09

Vote : 33
Quelques exemples :
quirfy29,1,1
smithjane,2,-1
mikej09,3,1

Signal : 40
Quelques exemples :
dorohills,5
kennysco,5
jadamsk,3

Answer : 55
Quelques exemples :
quirfy29,1
smithjane,2
mikej09,3

Hashtag : 40
Quelques exemples (tuples extraits des posts) :
adventure
nature
espace

HasHashtag : 42
Quelques exemples (tuples extraits des posts) :
adventure, 1
nature, 1
espace, 2

```

### insertions.sql
```
insert into Users values('quirfy29','John','Doe','john.doe@example.com','192.168.1.1','Utilisateur actif sur le réseau social.',date '2024-12-15','Violation of guidelines');
insert into Post values(1,'The quick brown fox jumps over the lazy dog. #adventure #nature',date '2024-03-15',null,null,'quirfy29');
insert into Survey values(1,'What is the best way to improve communication skills?',1);

```
### vote.csv
```
pseudo, idpost, valute
quirfy29,31,-1
smithjane,39,-1
mikej09,18,1
lindawil,33,1
brown_55,30,1
susie88,7,1
furyjams,32,-1
maryd8,34,-1
m_mart,17,1
pattie23,34,1
david34mo,37,-1
barbwhite,8,1
richeatay,34,-1
karenanna,3,-1
joseph56t,31,-1
nancyj10,8,1
charlttc,2,1
lisa_lh,27,-1
cmartinez,12,-1
clarks,20,-1
danl33,21,-1
walkerem,15,-1
phall92,31,-1
angieall,39,1
keviny25,4,1
dhernz,27,1
markkings,37,1
mwright45,15,-1
donaldlop,14,1
dorohills,27,-1
quirfy29,5,1
smithjane,15,-1
mikej09,25,1
```
### SQL\*Load
#### follow
##### control.txt
```
LOAD DATA INFILE '../follow.csv'
INTO TABLE Follow
FIELDS TERMINATED BY ','
(
    pseudo,
    follower
)
```
#### draft
##### control.txt
```
LOAD DATA INFILE '../draft.csv'
INTO TABLE Draft
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    iddraft,
    message,
    pseudo,
    state
)
```
#### signal
##### control.txt
```
LOAD DATA INFILE '../signal.csv'
INTO TABLE Signal
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    pseudo,
    idpost
)
```
#### receive
##### control.txt
```
LOAD DATA INFILE '../receive.csv'
INTO TABLE Receive
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    idpm,
    pseudo
)

```
#### private_message
##### control.txt
```
LOAD DATA INFILE '../private_message.csv'
INTO TABLE PrivateMessage
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    idpm,
    message,
    date_send date 'YYYY-MM-DD HH24-MI-SS',
    sender
)

```
#### vote
##### control.txt
```
LOAD DATA INFILE '../vote.csv'
INTO TABLE Vote
FIELDS TERMINATED BY ',' TRAILING NULLCOLS
(
    pseudo,
    idpost,
    value
)

```
#### answer
##### control.txt
```
LOAD DATA INFILE '../answer.csv'
INTO TABLE Answer
FIELDS TERMINATED BY ','
(
    pseudo,
    idoption
)
```
#### option
##### control.txt
```
LOAD DATA INFILE '../options.csv'
INTO TABLE Options
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
    idoption,
    content,
    idsurvey
)

```
#### survey
##### control.txt
```
LOAD DATA INFILE '../survey.csv'
INTO TABLE Survey 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    idsurvey,
    question,
    idpost
)


```
#### post
##### control.txt
```
LOAD DATA INFILE '../posts.csv'
INTO TABLE Post 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(
    idpost,
    message,
    date_post date "YYYY-MM-DD",
    room,
    building,
    pseudo
)


```
#### user
##### control.txt
```
LOAD DATA INFILE '../users.csv'
INTO TABLE Users 
FIELDS TERMINATED BY ',' TRAILING NULLCOLS
(  	pseudo,
    name,
    surname,
    mail,
    IPaddress,
    description,
    ban_end date "YYYY-MM-DD",
    ban_reason   
)


```
#### load.sh
```
#!/bin/bash

# Peuple la base de donnée à grâce à SQL*Load.

sqlldr userid=admin/banane control=user/control.txt log=user/log.txt bad=user/bad.txt discard=user/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=post/control.txt log=post/log.txt bad=post/bad.txt discard=post/discard.txt errors=0 skip=0
sqlldr userid=admin/banane control=survey/control.txt log=survey/log.txt bad=survey/bad.txt discard=survey/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=option/control.txt log=option/log.txt bad=option/bad.txt discard=option/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=answer/control.txt log=answer/log.txt bad=answer/bad.txt discard=answer/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=vote/control.txt log=vote/log.txt bad=vote/bad.txt discard=vote/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=private_message/control.txt log=private_message/log.txt bad=private_message/bad.txt discard=private_message/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=receive/control.txt log=receive/log.txt bad=receive/bad.txt discard=receive/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=signal/control.txt log=signal/log.txt bad=signal/bad.txt discard=signal/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=draft/control.txt log=draft/log.txt bad=draft/bad.txt discard=draft/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=follow/control.txt log=follow/log.txt bad=follow/bad.txt discard=follow/discard.txt errors=0 skip=1
```
### users.csv
```
pseudo,name,surname,mail,IPaddress,description,ban_end,ban_reason
quirfy29,John,Doe,john.doe@example.com,192.168.1.1,"Utilisateur actif sur le réseau social.",2024-12-15,"Violation of guidelines"
smithjane,Jane,Smith,jane.smith@example.com,192.168.1.2,"Explorateur de hashtags tendance.",,
mikej09,Mike,Johnson,mike.johnson@example.com,192.168.1.3,"Enjoying my time on this platform!",,
lindawil,Linda,Williams,linda.williams@example.com,192.168.1.4,"Découvrez de nouvelles fonctionnalités ici.",2025-03-22,"Violation of guidelines"
brown_55,Robert,Brown,robert.brown@example.com,192.168.1.5,"Always up for new challenges!",,
susie88,Susan,Jones,susan.jones@example.com,192.168.1.6,,,
furyjams,James,Garcia,james.garcia@example.com,192.168.1.7,"Enjoying my time on this platform!",,
maryd8,Mary,Davis,mary.davis@example.com,192.168.1.8,"Pas de sentiments ici.",2025-07-01,"Violation of guidelines"
m_mart,Mike,Martinez,michael.martinez@example.com,192.168.1.9,"Always up for new challenges!",,
pattie23,Patricia,Hernandez,patricia.hernandez@example.com,192.168.1.10,"Explorateur de hashtags tendance.",,
david34mo,David,Moore,david.moore@example.com,192.168.1.11,,,
barbwhite,Barbara,White,barbara.white@example.com,192.168.1.12,"Utilisateur actif sur le réseau social.",2024-12-30,"Violation of guidelines"
richeatay,Richard,Taylor,richard.taylor@example.com,192.168.1.13,"I'm a NoOb \0-0/",,
karenanna,Karen,Anderson,karen.anderson@example.com,192.168.1.14,"Découvrant de nouvelles fonctionnalités ici.",,
joseph56t,Joseph,Thomas,joseph.thomas@example.com,192.168.1.15,"Utilisateur actif sur le réseau social.",,
nancyj10,Nancy,Jackson,nancy.jackson@example.com,192.168.1.16,"Explorateur de hashtags tendance.",2025-01-10,"Violation of guidelines"
charlttc,Charles,Thompson,charles.thompson@example.com,192.168.1.17,"Always up for new challenges!",,
lisa_lh,Lisa,Harris,lisa.harris@example.com,192.168.1.18,"Enjoying my time on this platform!",,
cmartinez,Christopher,Martinez,christopher.martinez@example.com,192.168.1.19,"Découvrant de nouvelles fonctionnalités ici.",,
clarks,Clark,Sarah,sarah.clark@example.com,192.168.1.20,"Always up for new challenges!",2025-08-15,"Violation of guidelines"
danl33,Daniel,Lee,daniel.lee@example.com,192.168.1.21,"Enjoying my time on this platform!",,
walkerem,Emily,Walker,emily.walker@example.com,192.168.1.22,"Utilisateur actif sur le réseau social.",,
phall92,Paul,Hall,paul.hall@example.com,192.168.1.23,"Découvrant de nouvelles fonctionnalités ici.",,
angieall,Angela,Allen,angela.allen@example.com,192.168.1.24,,,
keviny25,Kevin,Young,kevin.young@example.com,192.168.1.25,"Explorateur de hashtags tendance.",2025-03-20,"Violation of guidelines"
dhernz,Dorothy,Hernandez,dorothy.hernandez@example.com,192.168.1.26,,,
markkings,Mark,King,mark.king@example.com,192.168.1.27,"Enjoying my time on this platform!",,
mwright45,Michelle,Wright,michelle.wright@example.com,192.168.1.28,"Always up for new challenges!",,
donaldlop,Donald,Lopez,donald.lopez@example.com,192.168.1.29,"Découvrant de nouvelles fonctionnalités ici.",,
dorohills,Dorothy,Hill,dorothy.hill@example.com,192.168.1.30,"Utilisateur actif sur le réseau social.",,
kennysco,Kenneth,Scott,kenneth.scott@example.com,192.168.1.31,,,
jgreen77,Jessica,Green,jessica.green@example.com,192.168.1.32,"Explorateur de hashtags tendance.",2024-12-25,"Violation of guidelines"
jadamsk,Jason,Adams,jason.adams@example.com,192.168.1.33,"Always up for new challenges!",,
shirlnelson,Shirley,Nelson,shirley.nelson@example.com,192.168.1.34,,,
brianb7,Brian,Baker,brian.baker@example.com,192.168.1.35,"Enjoying my time on this platform!",,
cynthia55,Cynthia,Carter,cynthia.carter@example.com,192.168.1.36,"Découvrant de nouvelles fonctionnalités ici.",,
georgem15,George,Mitchell,george.mitchell@example.com,192.168.1.37,"Utilisateur actif sur le réseau social.",2025-06-10,"Violation of guidelines"
laurarobs,Laura,Roberts,laura.roberts@example.com,192.168.1.38,"Always up for new challenges!",,
edp23,Edward,Phillips,edward.phillips@example.com,192.168.1.39,,,
rebcam99,Rebecca,Campbell,rebecca.campbell@example.com,192.168.1.40,"Explorateur de hashtags tendance.",,
```
### survey.csv
```
idsurvey,question,idpost
1,"What is the best way to improve communication skills?",1
2,"How do you define success in your own life?",2
3,"What motivates you to wake up every morning?",3
4,"Do you believe in the power of positive thinking?",4
5,"How do you stay focused while working from home?",5
6,"What is the importance of financial literacy today?",6
7,"Why is physical fitness essential for mental health?",7
8,"How can one overcome the fear of failure?",8
9,"What are your thoughts on artificial intelligence?",9
10,"Do you believe that history repeats itself?",10
11,"What is your opinion on climate change policies?",11
12,"How can technology enhance educational systems?",12
13,"What does happiness mean to you personally?",13
14,"Do you prefer working alone or in a team?",14
15,"What are the key traits of a good leader?",15
16,"Why is it important to have hobbies?",16
17,"What role does art play in our society?",17
18,"How do you handle criticism constructively?",18
19,"Do you believe humans will live on Mars someday?",19
20,"What are the benefits of learning new languages?",20
21,"What are the best practices for time management?",21
22,"How can one maintain work-life balance effectively?",28
23,"What is the most significant book you have read?",23
24,"How can we protect endangered species?",24
25,"What strategies help in building self-confidence?",25
26,"Why is volunteering beneficial for personal growth?",26
27,"How do you approach solving complex problems?",27
28,"What are the impacts of social media on youth?",28
29,"Why is critical thinking important in decision-making?",29
30,"What is your perspective on renewable energy sources?",30
31,"How can we encourage creativity in schools?",31
32,"What inspires you to take on new challenges?",32
33,"How do cultural differences shape our perspectives?",33
34,"What are the benefits of practicing mindfulness?",34
35,"Why is collaboration vital in achieving common goals?",35
```
### signal.csv
```
pseudo,idpost
quirfy29,5
smithjane,5
mikej09,5
lindawil,5
brown_55,5
susie88,5
furyjams,5
maryd8,5
m_mart,5
pattie23,5
david34mo,5
barbwhite,5
richeatay,5
karenanna,5
joseph56t,5
nancyj10,5
charlttc,5
lisa_lh,5
cmartinez,5
clarks,5
danl33,5
walkerem,5
phall92,5
angieall,5
keviny25,5
dhernz,5
markkings,5
mwright45,5
donaldlop,5
dorohills,5
kennysco,5
jadamsk,3
brianb7,7
georgem15,10
laurarobs,15
edp23,18
mikej09,22
quirfy29,30
smithjane,35
mikej09,40
```
### receive.csv
```
idpm,pseudo
1,smithjane
2,quirfy29
3,lindawil
4,mikej09
5,susie88
6,brown_55
7,maryd8
8,furyjams
9,pattie23
10,m_mart
11,barbwhite
12,david34mo
13,karenanna
14,richeatay
15,nancyj10
16,joseph56t
17,lisa_lh
18,charlttc
19,clarks
20,cmartinez
21,smithjane
22,quirfy29
23,lindawil
24,mikej09
25,susie88
26,brown_55
27,maryd8
28,furyjams
29,pattie23
30,m_mart
31,barbwhite
32,david34mo
33,karenanna
34,richeatay
35,nancyj10
36,joseph56t
37,lisa_lh
38,charlttc
39,clarks
40,cmartinez
41,smithjane
42,quirfy29
43,lindawil
44,mikej09
45,susie88
46,brown_55
47,maryd8
48,furyjams
49,pattie23
50,m_mart
51,barbwhite
52,david34mo
53,karenanna
54,richeatay
55,nancyj10
56,joseph56t
57,lisa_lh
58,charlttc
59,clarks
60,cmartinez
61,smithjane
62,quirfy29
63,lindawil
64,mikej09
65,susie88
66,brown_55
67,maryd8
68,furyjams
69,pattie23
70,m_mart
71,barbwhite
72,david34mo
73,karenanna
74,richeatay
75,nancyj10
76,joseph56t
77,lisa_lh
78,charlttc
79,clarks
80,cmartinez
```
### private_message.csv
```
idpm,message,date,sender
1,"I hope you are having a wonderful day.",2023-12-01 09:15:32,quirfy29
2,"Thank you! I am doing well. How about you?",2023-12-01 09:30:45,smithjane
3,"Did you see the latest updates on the project?",2023-12-02 11:05:12,mikej09
4,"Yes, I reviewed them this morning.",2023-12-02 11:20:18,lindawil
5,"Let’s meet tomorrow to finalize everything.",2023-12-03 14:50:25,brown_55
6,"Sounds good. I’ll bring the presentation.",2023-12-03 15:10:40,susie88
7,"Have you checked out the new feature?",2023-12-04 08:45:19,furyjams
8,"Not yet. I’ll look into it this evening.",2023-12-04 09:05:37,maryd8
9,"Can you send me the document by email?",2023-12-05 13:25:49,m_mart
10,"Sure, I’ll forward it to you shortly.",2023-12-05 13:40:03,pattie23
11,"What’s your favorite travel destination?",2023-12-06 18:15:21,david34mo
12,"I love the mountains. How about you?",2023-12-06 18:30:29,barbwhite
13,"Do you have any plans for the weekend?",2023-12-07 10:45:12,richeatay
14,"I might go hiking. What about you?",2023-12-07 11:00:45,karenanna
15,"Let’s catch up over coffee next week.",2023-12-08 09:30:17,joseph56t
16,"Sure! Monday works for me.",2023-12-08 09:45:56,nancyj10
17,"Did you finish the assignment already?",2023-12-09 14:10:34,charlttc
18,"Yes, I submitted it this morning.",2023-12-09 14:25:48,lisa_lh
19,"What do you think about the new policy changes?",2023-12-10 10:15:27,cmartinez
20,"I think they will be beneficial in the long run.",2023-12-10 10:30:13,clarks
21,"Can we reschedule the meeting to Thursday?",2023-12-11 16:20:42,quirfy29
22,"Sure, Thursday works better for me too.",2023-12-11 16:35:19,smithjane
23,"How was your weekend?",2023-12-12 08:50:32,mikej09
24,"It was relaxing. How about yours?",2023-12-12 09:05:22,lindawil
25,"Let’s collaborate on the next project.",2023-12-13 15:10:11,brown_55
26,"That’s a great idea. Let’s discuss the details.",2023-12-13 15:25:49,susie88
27,"Have you watched the new movie release?",2023-12-14 18:45:36,furyjams
28,"Yes, it was fantastic. You should watch it.",2023-12-14 19:00:12,maryd8
29,"Can you proofread my article draft?",2023-12-15 12:25:04,m_mart
30,"Of course. Send it to me anytime.",2023-12-15 12:40:29,pattie23
31,"What’s your favorite dish to cook?",2023-12-16 17:20:43,david34mo
32,"I love cooking pasta. How about you?",2023-12-16 17:35:16,barbwhite
33,"Do you think we should revise the timeline?",2023-12-17 09:40:22,richeatay
34,"Yes, we might need an extra week to complete it.",2023-12-17 09:55:47,karenanna
35,"Can you remind me of the meeting agenda?",2023-12-18 14:15:39,joseph56t
36,"Sure, I’ll send it to you after lunch.",2023-12-18 14:30:21,nancyj10
37,"What’s your favorite book genre?",2023-12-19 16:45:12,charlttc
38,"I enjoy reading mystery novels. What about you?",2023-12-19 17:00:33,lisa_lh
39,"Have you tried the new restaurant downtown?",2023-12-20 11:10:52,cmartinez
40,"Not yet, but I’ve heard great reviews about it.",2023-12-20 11:25:18,clarks
41,"What’s the best way to improve our workflow?",2023-12-21 10:05:14,quirfy29
42,"We should focus on automating repetitive tasks.",2023-12-21 10:20:42,smithjane
43,"Do you have any feedback on my presentation?",2023-12-22 15:35:19,mikej09
44,"It was excellent. I really liked your approach.",2023-12-22 15:50:24,lindawil
45,"Are you attending the conference next month?",2023-12-23 13:20:47,brown_55
46,"Yes, I’ve already registered for it.",2023-12-23 13:35:55,susie88
47,"Can we meet earlier to discuss the proposal?",2023-12-24 09:15:29,furyjams
48,"Yes, let’s meet at 8:30 AM instead.",2023-12-24 09:30:11,maryd8
49,"What are your thoughts on the current project status?",2023-12-25 14:40:22,m_mart
50,"I think we’re on track to meet the deadlines.",2023-12-25 14:55:33,pattie23
51,"Have you made your travel plans for the holidays?",2023-12-26 16:20:14,david34mo
52,"Yes, I’ll be visiting my family.",2023-12-26 16:35:41,barbwhite
53,"Can you join the team call tomorrow?",2023-12-27 11:10:57,richeatay
54,"Yes, I’ll be available at that time.",2023-12-27 11:25:19,karenanna
55,"What’s the best way to improve team collaboration?",2023-12-28 10:05:42,joseph56t
56,"Regular communication and shared goals help a lot.",2023-12-28 10:20:31,nancyj10
57,"Did you receive the latest project report?",2023-12-29 09:50:29,charlttc
58,"Yes, I reviewed it this morning.",2023-12-29 10:05:14,lisa_lh
59,"What’s your opinion on the new product launch?",2023-12-30 14:25:33,cmartinez
60,"I think it’s innovative and has great potential.",2023-12-30 14:40:47,clarks
61,"Can we extend the deadline for the submission?",2023-12-31 15:10:22,quirfy29
62,"Yes, let’s push it by another week.",2023-12-31 15:25:38,smithjane
63,"How do you plan to celebrate New Year’s Eve?",2024-01-01 17:30:25,mikej09
64,"I’ll have a quiet evening at home with family.",2024-01-01 17:45:52,lindawil
65,"Do you think we need to update the presentation slides?",2024-01-02 08:20:31,brown_55
66,"Yes, I’ll work on them this afternoon.",2024-01-02 08:35:18,susie88
67,"What’s your next travel destination?",2024-01-03 18:15:42,furyjams
68,"I’m planning to visit Japan next summer.",2024-01-03 18:30:27,maryd8
69,"Can we arrange a meeting next week?",2024-01-04 09:05:14,m_mart
70,"Sure, let’s decide on a suitable time.",2024-01-04 09:20:22,pattie23
71,"How do you stay motivated during tough times?",2024-01-05 14:40:36,david34mo
72,"I focus on my goals and stay optimistic.",2024-01-05 14:55:41,barbwhite
73,"What’s the best advice you’ve ever received?",2024-01-06 10:15:23,richeatay
74,"Never stop learning and growing.",2024-01-06 10:30:42,karenanna
75,"Are you free for a call later today?",2024-01-07 16:25:34,joseph56t
76,"Yes, I’ll call you after 5 PM.",2024-01-07 16:40:59,nancyj10
77,"What’s your favorite way to unwind?",2024-01-08 19:15:12,charlttc
78,"I enjoy listening to music or reading books.",2024-01-08 19:30:44,lisa_lh
79,"Can we finalize the details by tomorrow?",2024-01-09 13:10:22,cmartinez
80,"Yes, I’ll send you my inputs tonight.",2024-01-09 13:25:15,clarks
```
### posts.csv
```
1,"The quick brown fox jumps over the lazy dog. #adventure #nature",2024-03-15,,,"quirfy29"
2,"Un petit pas pour l homme, un grand pas pour l humanite. #espace",2024-07-22,,,"smithjane"
3,"Caminante, no hay camino, se hace camino al andar. #cultura",2024-01-19,"RoomA","BuildingX","mikej09"
4,"Ein kleiner Schritt fur einen Menschen, ein riesiger Sprung fur die Menschheit.",2024-04-05,"RoomB",,"lindawil"
5,"La vita e bella! #amore #famiglia",2024-08-18,,,"brown_55"
6,"Exploring the wonders of the universe. #science",2024-06-30,,"BuildingY","susie88"
7,"Voyagez a travers le temps et l espace. #aventure #exploration",2024-09-09,"RoomC","BuildingZ","furyjams"
8,"Das Leben ist wie ein Fahrrad. Du musst in Bewegung bleiben, um die Balance zu halten.",2024-11-22,,,"maryd8"
9,"Amor omnia vincit. #philosophia",2024-12-01,,,"m_mart"
10,"La curiosite est le moteur de la connaissance. #education",2024-10-15,"RoomD",,"pattie23"
11,"A smooth sea never made a skilled sailor. #motivation",2024-02-28,,,"david34mo"
12,"La patience est la cle du succes. #citation",2024-05-12,,"BuildingA","barbwhite"
13,"Les etoiles nous guident dans l obscurite. #espace #philosophie",2024-03-30,"RoomE","BuildingB","richeatay"
14,"Viaggio alla scoperta di nuovi orizzonti. #viaggi",2024-06-17,,,"karenanna"
15,"Mme Kloul qui connait pas son propre cours #genant #mal-boutonne",2024-09-25,,,"lisa_lh"
16,"Je suis presse, pas le temps dinventer un tweet",2024-09-25,,,"lisa_lh"
17,"Cest lheure daller manger au #crous sa mere g #faim",2024-09-25,,,"lisa_lh"
18,"pov: tas plus de #batterie",2024-09-25,,,"lisa_lh"
19,"non cest trop je desinstalle #leagueoflegends",2024-09-25,,,"lisa_lh"
20,"Il futuro appartiene a coloro che credono nella bellezza dei propri sogni. #inspirazione",2024-12-12,,"BuildingC","nancyj10"
21,"Through hardships to the stars. #inspiration #dreams",2024-03-05,"RoomF",,"charlttc"
22,"Le bonheur n est reel que lorsqu il est partage. #amitie",2024-07-10,,,"lisa_lh"
23,"Nada te turbe, nada te espante. #fe #esperanza",2024-11-02,,,"cmartinez"
24,"Leben ist, was passiert, wahrend du beschaftigt bist, andere Plane zu machen.",2024-08-08,"RoomG","BuildingD","clarks"
25,"Ogni nuovo giorno e un opportunita. #speranza",2024-06-04,,"BuildingE","danl33"
26,"The best way to predict the future is to create it. #innovation",2024-01-21,"RoomH",,"walkerem"
27,"Un instant de calme dans un monde de chaos. #reflexion",2024-04-11,,,"phall92"
28,"Siempre hay luz detras de las nubes. #esperanza",2024-02-16,,"BuildingF","angieall"
29,"La vie est belle quand on sait la regarder. #positivite",2024-05-27,,,"keviny25"
30,"Jedes Ende ist ein neuer Anfang. #leben",2024-12-07,,,"dhernz"
31,"Viva la vida y no dejes de sonar. #suenos",2024-03-19,"RoomI",,"markkings"
32,"L education est l arme la plus puissante pour changer le monde. #savoir",2024-09-14,,"BuildingG","mwright45"
33,"Fai quello che ami e non lavorerai un solo giorno della tua vita.",2024-10-20,"RoomJ","BuildingH","donaldlop"
34,"The journey of a thousand miles begins with a single step. #adventure",2024-08-01,,,"dorohills"
35,"La simplicite est la sophistication supreme. #design",2024-06-25,,,"kennysco"
36,"Cada dia es una nueva oportunidad para ser feliz. #vida",2024-07-19,"RoomK",,"jgreen77"
37,"L espoir fait vivre. #espoir",2024-04-24,,"BuildingI","jadamsk"
38,"Man soll die Feste feiern, wie sie fallen.",2024-05-30,"RoomL","BuildingJ","shirlnelson"
39,"Das Leben ist wie ein Puzzle. Manchmal fehlen Teile. #nachdenken",2024-12-10,,,"brianb7"
40,"Les reves sont faits pour etre realises. #reves",2024-11-25,,,"cynthia55"
```
### options.csv
```
idoption,content,idsurvey
1,"Spend more time communicating with others.",1
2,"Practice active listening daily.",1
3,"Set clear goals for personal achievements.",2
4,"Define what happiness means to you.",2
5,"Focus on what inspires you every day.",3
6,"Think about your passions and goals.",3
7,"Maintain a positive attitude and smile.",4
8,"Use affirmations to boost your confidence.",4
9,"Create a dedicated workspace at home.",5
10,"Set strict working hours to stay productive.",5
11,"Understand basic budgeting principles.",6
12,"Learn how to invest your savings wisely.",6
13,"Engage in regular exercise routines.",7
14,"Adopt a balanced diet and mindfulness.",7
15,"Take small, calculated risks.",8
16,"Seek advice from a mentor or coach.",8
17,"Embrace the potential of innovation.",9
18,"Consider ethical implications in development.",9
19,"Analyze historical patterns carefully.",10
20,"Reflect on lessons learned from the past.",10
21,"Advocate for stricter regulations on emissions.",11
22,"Support renewable energy projects worldwide.",11
23,"Incorporate technology in lesson planning.",12
24,"Provide students with interactive learning tools.",12
25,"Pursue hobbies that bring you joy.",13
26,"Focus on relationships that matter most.",13
27,"Collaborate with peers for better results.",14
28,"Value diverse perspectives in teamwork.",14
29,"Stay adaptable to different situations.",15
30,"Exhibit empathy towards your team members.",15
31,"Pick activities that align with your interests.",16
32,"Experiment with creative pursuits regularly.",16
33,"Support public funding for museums and art.",17
34,"Encourage young artists through education.",17
35,"Learn to process feedback constructively.",18
36,"Identify areas for self-improvement actively.",18
37,"Stay informed about new scientific discoveries.",19
38,"Discuss future possibilities with peers.",19
39,"Enroll in language courses near your area.",20
40,"Practice with native speakers regularly.",20
41,"Consider alternative viewpoints during discussions.",21
42,"Explore innovative ways to balance priorities.",22
43,"Discuss the relevance of old classics.",23
44,"Promote awareness about conservation efforts.",24
45,"Incorporate positive affirmations into your routine.",25
46,"Engage with diverse communities for better understanding.",26
47,"Develop structured frameworks for problem-solving.",27
48,"Reflect on the long-term impact of social media.",28
49,"Analyze case studies on decision-making strategies.",29
50,"Propose incentives for adopting green practices.",30
51,"Encourage open-ended thinking in assignments.",31
52,"Challenge yourself to think outside the box.",32
53,"Celebrate cultural diversity through events.",33
54,"Integrate relaxation techniques into daily life.",34
55,"Work collaboratively to achieve meaningful results.",35
```
### follow.csv
```
pseudo,follower
quirfy29,smithjane
mikej09,lindawil
brown_55,susie88
furyjams,maryd8
m_mart,pattie23
david34mo,barbwhite
richeatay,karenanna
joseph56t,nancyj10
charlttc,lisa_lh
cmartinez,clarks
danl33,walkerem
phall92,angieall
keviny25,dhernz
markkings,mwright45
donaldlop,dorohills
kennysco,jgreen77
jadamsk,shirlnelson
brianb7,cynthia55
georgem15,laurarobs
edp23,rebcam99
smithjane,quirfy29
lindawil,mikej09
susie88,brown_55
pattie23,m_mart
barbwhite,david34mo
karenanna,richeatay
nancyj10,joseph56t
lisa_lh,charlttc
clarks,cmartinez
walkerem,danl33
angieall,phall92
dhernz,keviny25
mwright45,markkings
dorohills,donaldlop
jgreen77,kennysco
shirlnelson,jadamsk
cynthia55,brianb7
laurarobs,georgem15
rebcam99,edp23
quirfy29,mikej09
smithjane,brown_55
lindawil,susie88
maryd8,furyjams
pattie23,barbwhite
david34mo,karenanna
richeatay,nancyj10
joseph56t,lisa_lh
charlttc,cmartinez
clarks,walkerem
danl33,phall92
keviny25,markkings
dhernz,donaldlop
mwright45,jgreen77
kennysco,shirlnelson
jadamsk,cynthia55
brianb7,laurarobs
georgem15,rebcam99
edp23,quirfy29
smithjane,mikej09
mikej09,susie88
lindawil,maryd8
brown_55,pattie23
furyjams,david34mo
m_mart,richeatay
pattie23,joseph56t
barbwhite,charlttc
karenanna,clarks
nancyj10,walkerem
lisa_lh,phall92
clarks,keviny25
walkerem,dhernz
angieall,mwright45
dhernz,kennysco
mwright45,jadamsk
donaldlop,brianb7
kennysco,georgem15
jadamsk,edp23
brianb7,quirfy29
georgem15,smithjane
```
### draft.csv
```
iddraft,message,pseudo
1,"The quick brown fox jumps over the lazy dog.",quirfy29
2,"A journey of a thousand miles begins with a single step.",smithjane
3,"Life is what happens when you're busy making other plans.",mikej09
4,"To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.",lindawil
5,"In the middle of every difficulty lies opportunity.",brown_55
6,"Success usually comes to those who are too busy to be looking for it.",susie88
7,"Do not watch the clock. Do what it does. Keep going.",furyjams
8,"The future belongs to those who believe in the beauty of their dreams.",maryd8
9,"The best way to predict the future is to invent it.",m_mart
10,"Don’t count the days, make the days count.",pattie23
11,"You miss 100% of the shots you don’t take.",david34mo
12,"Life is really simple, but we insist on making it complicated.",barbwhite
13,"The only limit to our realization of tomorrow will be our doubts of today.",richeatay
14,"The way to get started is to quit talking and begin doing.",karenanna
15,"It always seems impossible until it’s done.",joseph56t
16,"What lies behind us and what lies before us are tiny matters compared to what lies within us.",nancyj10
17,"Do what you can, with what you have, where you are.",charlttc
18,"A man who dares to waste one hour of time has not discovered the value of life.",lisa_lh
19,"Happiness is not something ready made. It comes from your own actions.",cmartinez
20,"Don’t wait. The time will never be just right.",clarks
21,"Everything you’ve ever wanted is on the other side of fear.",danl33
22,"Dream big and dare to fail.",walkerem
23,"What you get by achieving your goals is not as important as what you become by achieving your goals.",phall92
24,"Do not go where the path may lead, go instead where there is no path and leave a trail.",keviny25
25,"The purpose of our lives is to be happy.",dhernz
26,"In order to write about life first you must live it.",markkings
27,"Turn your wounds into wisdom.",mwright45
28,"The mind is everything. What you think you become.",donaldlop
29,"Keep smiling, because life is a beautiful thing and there’s so much to smile about.",kennysco
30,"Life is short, and it is up to you to make it sweet.",jadamsk
31,"Success is not the key to happiness. Happiness is the key to success.",brianb7
32,"Believe you can and you're halfway there.",georgem15
33,"Life is ten percent what happens to us and ninety percent how we respond to it.",laurarobs
34,"Your time is limited, so don’t waste it living someone else’s life.",edp23
35,"Life itself is the most wonderful fairy tale.",rebcam99
```
### answer.csv
```
pseudo,idoption
quirfy29,1
smithjane,2
mikej09,3
lindawil,4
brown_55,5
susie88,6
furyjams,7
maryd8,8
m_mart,9
pattie23,10
david34mo,11
barbwhite,12
richeatay,13
karenanna,14
joseph56t,15
nancyj10,16
charlttc,17
lisa_lh,18
cmartinez,19
clarks,20
danl33,21
walkerem,22
phall92,23
angieall,24
keviny25,25
dhernz,26
markkings,27
mwright45,28
donaldlop,29
dorohills,30
kennysco,31
jadamsk,32
brianb7,33
georgem15,34
laurarobs,35
edp23,36
rebcam99,37
quirfy29,38
smithjane,39
mikej09,40
lindawil,41
brown_55,42
susie88,43
furyjams,44
maryd8,45
m_mart,46
pattie23,47
david34mo,48
barbwhite,49
richeatay,50
karenanna,51
joseph56t,52
nancyj10,53
charlttc,54
lisa_lh,55
cmartinez,56
clarks,57
danl33,58
walkerem,59
phall92,60
angieall,61
keviny25,62
dhernz,63
markkings,64
mwright45,65
donaldlop,66
dorohills,67
kennysco,68
jadamsk,69
brianb7,70
georgem15,71
laurarobs,72
edp23,73
rebcam99,74
quirfy29,75
smithjane,76
mikej09,77
lindawil,78
brown_55,79
susie88,80
```

## C/ Manipulation des donées
### moderator
#### moderator.sql
```
-- R28 : Quelle est l'adresse IP de pseudo ?
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

-- Droits d'éxécution des procédures/fonctions :
grant execute on get_IPadress to client, moderator;
```
### create_requests.sql
```
-- admin
@requests/admin/admin_procedures.sql

-- client
@requests/client/post.sql
@requests/client/activities.sql
@requests/client/users.sql
@requests/client/survey.sql
@requests/client/hashtag.sql
@requests/client/draft.sql
@requests/client/message_thread.sql

-- moderator
@requests/moderator/moderator.sql

@rights/client_execute.sql
```
### client
#### post.sql
```
-- Requêtes concernant les Posts

-- R8 : Quels sont les récents posts de [TARGET_USER] ?
select *
from admin.Post
where pseudo = 'lulu'
order by date_post desc;

-- R9 : Quels sont les post émis depuis [BUILDING] et/ou [ROOM] ?
select *
from admin.Post
where building = 'Fermat'
and room = 'Amphi J'
order by date_post desc;

-- R10 : Quels sont les posts postés entre [DATE_START] et [DATE_END] ?
select *
from admin.Post
where date_post between date '2012-08-30' and date '2012-10-11'
order by date_post desc;

-- R11 : Quels sont les [N] posts les plus récents ?
select *
from admin.Post
order by date_post desc
fetch first 15 rows only;

-- R12 : Quels sont les posts contenant [WORD] ?

-- Fonction pour vérifier si un mot est contenu dans la chaîne de caractère passée en entrée
select *
from admin.Post
where REGEXP_LIKE(message, 'Banane', 'i') = TRUE
order by date_post desc;

-- R13 : Quels sont les posts utilisant [HASHTAG] ?
select *
from admin.Post
where idpost in (
    select idpost 
    from admin.HasHashtag
    where hashtag= 'genant')
order by date_post desc;

-- R14 : Quels sont les posts les plus upvoté (ou downvoté) ?
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

select P.idpost, P.message, P.date_post, P.room, P.building, P.pseudo, NVL(V.rank, 0) as rank
from admin.Post P
left join (
    select V.idpost, count(V.pseudo) as rank
    from admin.Vote V
    where V.value = -1
    group by V.idpost
) V
on P.idpost = V.idpost
order by rank desc;

-- Bonus : Quels sont les utilisateurs qui ont voté pour tous les posts
select pseudo
from admin.Vote
group by pseudo
having count(idpost) = (select count(*) from admin.Post);
```
#### hashtag.sql
```
-- R15 : Quels utilisateurs ont utilisé les hashtags en tendance 
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

-- R16 : Quelle est la proportion de hashtags en tendance utilisés par [TARGET_USER] ?
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

-- R17 : Quel sont les hashtags les plus fréquemment postés avec le hashtag [a] ?
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

-- R18 : Quel est le jour durant lequel un hashtag [HASHTAG] a été le plus posté ?
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
#### message_thread.sql
```
-- R26 : Quelles sont mes dernières discussions privées ?
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

-- R27 : Quelle est la proportion de messages envoyés/reçus entre [moi] et l'utilisateur [TARGET_USER] ?
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

create or replace function new_id_private_message return number AS
	RESULT number(6);
begin
	select NVL(max(idpm)+1, 0) into RESULT
	from PrivateMessage;

	return RESULT;
end;
/

create or replace procedure send_message(msg IN varchar, recipients_csv IN varchar) as
	new_id number(6)      := new_id_private_message;
	field_index number(6) := 0;
	current varchar(1)    := '';
	buffer varchar(64)    := '';

begin

	insert into PrivateMessage values (new_id, msg, current_date, lower(user));

	-- Pour chaque champ du CSV, on insert dans Receive.

	-- On itère sur chaque caractère du CSV.
	for j in 1..length(recipients_csv) loop

		current := substr(recipients_csv, j, 1);

		-- Fin d'un champ
		if current = ',' then
			dbms_output.put_line('new receive : {'||new_id||','||buffer||'}');

			insert into Receive values (new_id, buffer);
			buffer := '';
			field_index := field_index + 1; 
		else
			buffer := buffer || current;
		end if;

	end loop;
	
	dbms_output.put_line('buffer : '||buffer);
	-- On envoie le dernier champ si le CSV de se finit pas par ','
	if length(buffer) > 0 then
		dbms_output.put_line('new receive : {'||new_id||','||buffer||'}');
		insert into Receive values (new_id, buffer);
	end if;

end;
/
```
#### draft.sql
```
-- R24 : Quel est le brouillon le plus récent que j'ai rédigé ?
select message
from admin.MyDraft
fetch first 1 rows only;

-- R25 : Quel est le draft (brouillon) le plus long que j'ai rédigé ?
select message
from admin.MyDraft
where length(message) = (select max(length(message)) from admin.MyDraft);
```
#### activities.sql
```
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

create or replace function new_idpost return number AS
	RESULT number(6);
begin
	select NVL(max(idpost)+1, 0) into RESULT
	from Post;

	return RESULT;
end;
/

create or replace function new_idsurvey return number AS
	RESULT number(6);
begin
	select NVL(max(idsurvey)+1, 0) into RESULT
	from Survey;

	return RESULT;
end;
/

create or replace function new_idoption return number AS
	RESULT number(6);
begin
	select NVL(max(idoption)+1, 0) into RESULT
	from Options;

	return RESULT;
end;
/

-- Ajout de la location d'un post
create or replace procedure update_location(room in varchar, buiding in varchar) as
begin
	update Post set room = room, building = building
	where pseudo = lower(user);
end;
/

-- Seul et unique moyen d'ajouter des posts dans la base de donnée
-- pour l'utilisateur lambda.
create or replace procedure add_post(msg IN varchar, room IN varchar, building IN varchar) as
	id varchar(32) := 'none';
begin
	if is_post_cooldown_up = FALSE then
		raise_application_error(-20589, 'Please wait at least 2 seconds before posting again.');
	else
		insert into Post values (new_idpost, msg, current_date, room, building, lower(user));
	end if;
end;
/

-- Permet à l'utilisateur de modifier l'attribut validate de l'un de ses brouillons (draft)
create or replace procedure validate_draft(id in number, state in boolean) as
begin
	update Draft set state = state where iddraft = id;
end;
/

-- Permet à l'utilisateur de signaler un post
create or replace procedure add_signal(TARGET_USER in varchar, ID_POST in number) as
begin
	insert into Signal values(TARGET_USER, ID_POST);
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
```
#### users.sql
```
-- REQUÊTES UTILISATEURS

-- 1 - Quelle est la liste des hashtags utilisés par [TARGET_USER] ?
select distinct HH.hashtag
from admin.HasHashtag HH, admin.Post P
where HH.idpost = P.idpost
and P.pseudo = 'lulu';

-- 2 - Quelle est la moyenne des votes des posts de [TARGET_USER] ?
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

-- 3 - Est-ce que [pseudo] est suivi par au moins un des utilisateurs que je suis ?
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

-- 4 - Quels sont les utilisateurs que je suis et qui me suivent ?
SELECT F1.follower AS mutual_follow
FROM admin.Follow F1, admin.Follow F2
WHERE F1.follower = F2.pseudo
AND F1.pseudo = lower(user) AND F2.follower = lower(user);

-- 5 - Quels sont les utilisateurs qui suivent [pseudo] ET qui sont suivis par [pseudo] ?
SELECT F1.follower AS mutual_follow
FROM admin.Follow F1
JOIN admin.Follow F2 ON F1.follower = F2.pseudo
WHERE F1.pseudo = 'jojo' AND F2.follower = 'lulu';

-- 6 - Quels sont les utilisateurs que je suis mais qui ne me suivent pas ?
SELECT F1.follower AS not_following_back
FROM admin.Follow F1
LEFT JOIN admin.Follow F2 ON F1.follower = F2.pseudo AND F2.follower = lower(user)
WHERE F1.pseudo = lower(user) AND F2.pseudo IS NULL;

-- 7 - Quel est l'utilisateur qui approuve/désapprouve le plus de mes posts ?
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
#### survey.sql
```
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

-- R19 : Quels sont les sondages contenant [mot] dans sa question ?
select *
from admin.Survey
where REGEXP_LIKE(question, 'genant', 'i') = TRUE;

-- R20 : Quels sont les sondages contenant [mot] dans ces options ?
-- Procedure instable
select *
from admin.Survey
where idsurvey in (
    select idsurvey
    from admin.Options
    where REGEXP_LIKE(content, 'Oui', 'i') = TRUE
);

-- R21 : Quel est le pourcentage d'utilisateurs ayant choisi cette [option] à cette [question] ?
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

-- R22 : Quels sont les sondages contenant le plus de votants ?
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

-- R23 : Quels sont les sondages contenant [N] options ?
select *
from admin.Survey
where idsurvey in (
    select idsurvey
    from admin.Options
    group by idsurvey
    having count(distinct idoption) = 2
);
```
### admin
#### admin_procedures.sql
```
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

-- Procédure permettant l'ajout d'un nouveau post
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
## D/ Vues et droits
### my_messages.sql
```
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
### my_draft.sql
```
-- Procédure créant ou remplaçant la vue MyDraft
-- Vue modélisant les brouilons (drafts) de l'utilsateur

create or replace view MyDraft as
select * 
from Draft 
where pseudo = lower(user)
order by iddraft desc;

grant select, update, delete on MyDraft to client, moderator;
```
### my_data.sql
```
create or replace view MyData as
select *
from Users
where pseudo = lower(user);

grant select, update on MyData to client, moderator;
```
### grades.sql
```
-- Procédure créant ou remplaçant la vue Influencer
-- Vue modélisant les utilisateurs faisant parti du N%
-- des utilisateurs en fonction de leur rank


-- grant select on Goat to client, moderator;

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

create or replace view Goat as select
  pseudo, rank
from
  Rank
where
  rownum <= 0.1 * get_user_count;

grant select on Goat to client, moderator;

create or replace view Influencer as select
  pseudo, rank
from
  Rank
where
  rownum > 0.1 * get_user_count and
  rownum <= 0.5 * get_user_count;

grant select on Influencer to client, moderator;

create or replace view Nobody as select
  pseudo, rank
from
  Rank
where
  rownum > 0.5 * get_user_count;

grant select on Nobody to client, moderator;
```
### user_ranks.sql
```
-- Procédure créant ou remplaçant la vue Rank
-- Vue modélisant le rank de tous les utilisateurs

create or replace view Rank as
select Post.pseudo as pseudo, sum(Vote.value) as rank
from Post, Vote
where Post.idpost = Vote.idpost
group by Post.idpost, Post.pseudo
order by rank desc;

grant select on Rank to client, moderator;
```
### urgent_signal.sql
```
-- Procédure créant ou remplaçant la vue UrgentSignal
-- Vue modélisant les posts signalés plus de 30 fois

create or replace view UrgentSignal as
select idpost
from Signal
group by idpost
having count(*) >= 30;

grant select on UrgentSignal to moderator;
```
### top_user.sql
```
-- Procédure créant ou remplaçant la vue TopUser
-- Vue modélisant le classement des utilisateurs les plus suivis

create or replace view TopUser as
select Users.pseudo, count(*) as nb_followers
from Users left join Follow on Users.pseudo=Follow.pseudo
group by Users.pseudo
order by nb_followers desc;

grant select on TopUser to client, moderator;
```
### tendance.sql
```
-- Procédure créant ou remplaçant la vue Tendance
-- Vue modélisant les hashtags (tendance) des 7 derniers jours

create or replace view Tendance as
select HH.hashtag as hashtag, count(HH.idpost) as nb_posts
from HasHashtag HH, Post P
where P.idpost=HH.idpost and P.date_post>=(SYSDATE-7)
group by HH.hashtag
order by nb_posts desc 
fetch first 10 rows only;

grant select on Tendance to client, moderator;
```
### sanctions.sql
```
-- Procédure créant ou remplaçant la vue Sanctions
-- Vue modélisant le temps restant avant la fin du banissement des utilisateurs bannis

create or replace view Sanctions as
select pseudo, ban_end - SYSDATE as time_left, ban_reason
from Users
where SYSDATE < ban_end;

grant select on Sanctions to client, moderator;
```
### rank_post.sql
```
-- Procédure créant ou remplaçant la vue RankPost
-- Vue modélisant les statistiques d'un post donné

create or replace view RankPost as
select sum(value) as rank,
   sum(case when Vote.value > 0 then 0 else 1 end) as downvotes,
   sum(case when Vote.value > 0 then 1 else 0 end) as upvotes
from Vote
group by idpost;

grant select on RankPost to client, moderator;
```
### feed.sql
```
-- Vue modélisant le fil d'actualité de l'utilisateur

create or replace view Feed as
select * from Post
where pseudo in (select pseudo from Follow where follower=lower(user))
order by date_post desc;

grant select on Feed to client, moderator;
```

### client_execute.sql
```
-- Droits d'exécution des Fonctions / Procédures utilisées par le role client :

-- activities :

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

-- hashtag :

grant execute on get_proportion_hashtag to client, moderator;
grant execute on max_frequency_hashtag to client, moderator;
grant execute on get_hashtag_day to client, moderator;

-- message_thread :

grant execute on get_proportion_message to client, moderator;
grant execute on new_id_private_message to client, moderator;
grant execute on send_message to client, moderator;

-- survey :

grant execute on add_survey to client, moderator;
grant execute on add_option to client, moderator;
grant execute on add_answer to client, moderator;
grant execute on survey_result to client, moderator;

-- users :

grant execute on get_average_rank_post to client, moderator;
grant execute on get_linked_user to client, moderator;

-- views/grades :
grant execute on get_user_count to client, moderator;
```
### moderator.sql
```
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
```
### client.sql
```
-- /!\ Attention ! On ne peut pas donner les droits sur les
--     procédures ici car les utilisateurs sont crées avant
--     les procédures dans l'ordre d'execution spécifié dans
--     le README.md. Je les ai déplacé à la fin de "rights/client_procedures.sql"

create role client;
grant create session to client;
grant create view to client;

-- Droits de sélection sur certaines tables :
grant select on Post to client, moderator;
grant select on Survey to client, moderator;
grant select on Options to client, moderator;
grant select on Answer to client, moderator;
grant select on Follow to client, moderator;
grant select on Vote to client, moderator;
grant select on Hashtag to client, moderator;
grant select on HasHashtag to client, moderator;


-- Utilisateurs test, normalement les utilisateurs doivent
-- être crées par l'admin.
call add_user('jean', 'jean@jean.fr', 'pasteque');
call add_user('lola', 'lola@lola.fr', 'kiwi');

```
### admin.sql
```
-- Administrateur de la BD
-- C'est lui qui crée les tables, les vues, les triggers, etc.

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

## E/ Intégrité des données
### user_activities.sql
```
-- On empêche les utilisateur de voter pour leurs propres posts
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


-- On empêche les utilisateurs de s'envoyer des messages à eux même
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

-- On ajoute un utilisateur de la BD à chaque insertion dans la table Users
create or replace trigger user_creation before insert on Users for each row
declare
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    execute immediate 'alter session set "_oracle_script" = true';
    execute immediate 'create user ' || :new.pseudo || ' identified by ' || 'changeme';
    execute immediate 'grant client to ' || :new.pseudo;
end;
/

-- Insertion automatique des hashtags d'un post
create or replace trigger extract_hashtags after insert on Post for each row
begin
    admin.parse_hashtags(:new.idpost, :new.message);
end;
/

```
### user_ban.sql
```
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

## F/ Méta-données
### liste_ora_users.sql
```
-- Renvoie la liste de tous les utilisateurs de la BDD
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
### liste_ora_trigger.sql
```
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
### liste_ora_constraints.sql
```
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
# Projet-IN513

&nbsp;&nbsp;&nbsp;Cette base de donnée vise à être utilisable comme un réseau social à l'échelle de la fac. Les utilisateurs
pourront poster, lire et réagir à des messages sur le Feed ainsi que s'envoyer des messages privés.

## Installation

&nbsp;&nbsp;&nbsp;&nbsp;Cette repository contient tous les scripts nécessaire à la création de notre base de donnée.
Le fichier ```build_database.sql``` référence tous les scripts dans l'ordre d'appel. Pour construire la base de donnée il faut
executer les commandes suivantes :
```
> cd /chemin/vers/la/repo/Projet-IN513/
> sqlplus
[entrez les identifiants administrateurs de la BD]
> @build_database.sql
```

## Exemples

&nbsp;&nbsp;&nbsp;&nbsp;Le dossier exemple contient diverses requêtes
montrant les possibilités de la base de donnée. 

## A faire

1. Créer les tables
1. Créer les vues
1. Créer les contraintes d'intégrité
1. Donner les droits
1. Peupler la base de données
1. Ecrire les exemples
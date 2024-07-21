# Exercices techniques Panasonic

Tout les exercies sont separes dans leurs dossiers respectifs.
Le language utilise est Ruby, le framework Ruby On Rails a ete utilise pour l'exercice.

Pico CSS a ete utilise pour stylise rapidement les formulaires

Aucune dependence supplementaire n'est necessaire pour lancer le projet Rails (Exercice 3)

## Instructions exercice 3
Les dependances necessaires sont :
Ruby 3.2.2
Rails 7.1.3.4
sqlite 3

Pour Ruby, il est recommander d'utilise [rbenv](https://github.com/rbenv/rbenv).

Pour executer le projet, utiliser les commandes suivantes :
```
rbenv install 3.2.2 # Installe la version 3.2.2 de ruby
cd exercice_3 && rbenv local 3.2.2 # On rentre dans le dossier du projet et change la version local (la version specifique au dossier) a la 3.2.2
bundle install # Installe les dependences necessaire
```

Afin de lancer le serveur, on creer la base au prealable
```
rails db:migrate
```

Puis on lance le serveur

```
rails s
```

L'application est maintenant disponible sur notre navigateur.
La page est disponible sous la route ```.../orders```.

Il est possible de changer la route pour ouvrir la page sur l'index, dans le fichier ```config/routes.rb```
```
...
root "orders#index"
```

La base de donnees (SQLite3) n'est pas disponible dans ce repository.

Je conseille de creer plusieurs entites au travers de la console rails afin de tester le filtrage.

```
rails c
```



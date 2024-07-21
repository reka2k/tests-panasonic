# Pour le context, on assume que dans ce fichier sont 2 helper functions qui sont utilisées dans le controller du système de comande d'achat.
# Ce sont des fonctions de validation de données pour l'en-tête et les lignes d'achat.
# Les fonctions sont les suivantes:
# - validate_header(header) qui valide l'en-tête de la commande
# - validate_lines(lines) qui valide les lignes de la commande
# Ces fonctions retournent un boolean qui indique si les données sont valides ou non.

# On assume que l'application est une application Rails et que les modèles User, Provider (Fournisseur), OrderHeader (En-tete), OrderDetail existent et heritent de la classe ApplicationRecord.
# On assume que les modèles sont defini dans la base de données et que les relations entre les modèles sont correctement définies.

# On assume que les IDs respectifs aux modèles sont générés automatiquement par la base de données, ainsi que le champs created_at (par défaut la fonction now() de la base de données)
# Les champs status ont une valeur par defaut de "Ouvert" lors de d'insert en base de données.

# Retourne :
# - true si l'en-tête est valide
# - false si l'en-tête n'est pas valide
def validate_header(header)
  err = []
  Provider.find_by(header.provider_id).nil? err << 'Fournisseur innexistant'
  User.find_by(header.created_by).nil? err << 'Utilisateur innexistant'
  err.empty? ? true : false and p err
end

def validate_order_detail(order_detail)
  err = []
  Article.find_by(order_detail.article_id).nil? err << 'Produit innexistant'
  Header.find_by(order_detail.header_id).nil? err << 'En-tête innexistant'
  User.find_by(order_detail.created_by).nil? err << 'Utilisateur innexistant'

  if order_detail.ordered_quantity <= 0 || order_detail.ordered_quantity.nil? then err << 'Quantité invalide' end
  if order_detail.prefered_delay < Date.today then err << 'Date de de delai demande invalide' end
  if order_detail.unit_price <= 0 || order_detail.unit_price.nil? then err << 'Prix unitaire invalide' end
  if order_detail.unit_price.is_a? Numeric then err << 'Prix unitaire invalide' end

  err.empty? ? true : false and p err
end

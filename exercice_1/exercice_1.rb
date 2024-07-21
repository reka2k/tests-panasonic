# Exercice 1 :
# Ecrire une fonction permettant d'enregistrer une transaction de stock et de mettre à jour les données des tables correspondantes
# (Tables : Transaction, Articles, Details Stock)

# Pour le contexte de la question, on considère que les tables sont déjà créées et que les champs sont déjà définis.
# Ainsi que l'application est developper en Ruby on Rails, que les models sont déjà créés et que toutes les fonctions du model parent ApplicationRecord sont disponibles.
# On considère également que les tables sont déjà remplies avec des données.
# On assume qu'une methode de validation est déjà définie dans le model Transaction pour vérifier si la transaction est valide.

# Plusieurs types de movement sont possibles :
# - 'INV' : Inventaire (ajout ou retrait de stock)
# - 'RCPT' : Réception d'achat (ajout de stock)
# - 'VNT' : Vente (retrait de stock)
# - 'OFC' : Consommation sur ordre de fabrication (retrait de stock)
# = 'OFP' : Production d'un ordre de fabrication (ajout de stock)
def save_transaction(transaction)
  # On commence par verifier si la transaction est valide avant de l'enregistrer en base de données
  raise 'Transaction non valide' and return unless transaction.valid?

  transaction.save

  # On met à jour les données des tables correspondantes
  update_stock(transaction)
end

# Helper function pour mettre a jour le stock et le stock detail d'un article
# Lors d'un retrait de stock, si la quantite est superieur au stock actuel, on leve une exception
# Si lors d'un retrait, le stock est egale a 0 apres le retrait, on met a jour la disponibilite de l'article
def update_stock(transaction)
  article = Article.find(transaction.article_id)
  detail_stock = DetailStock.find_by(article_id: transaction.article_id)

  if transaction.quantity.negative? && article.stock < transaction.quantity.abs then raise 'Quantité insuffisante' end

  if transaction.quantity.negative? && article.stock - transaction.quantity.abs == 0 then detail_stock.statut_dispo = false end

  case transaction.type
  when 'INV', 'RCPT', 'OFP'
    transaction.quantity.negative? article.stock_totale_non_dispo += transaction.quantity.abs
    article.stock_totale_dispo += transaction.quantity
    detail_stock.quantite += transaction.quantity

  when 'VNT'
    article.stock_totale_non_dispo -= transaction.quantity
    article.stock_totale_dispo += transaction.quantity
    detail_stock.quantite += transaction.quantity
    article.quantite_attente_vente += transaction.quantity

  when 'OFC'
    article.stock_totale_non_dispo += transaction.quantity
    article.stock_totale_dispo += transaction.quantity
    detail_stock.quantite += transaction.quantity
    article.quantite_attente_fabrication += transaction.quantity
  end
end

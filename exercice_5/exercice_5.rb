# Pour changer un article d'emplacement dans le stock il faut :
# - Vérifier que l'article existe
# - Vérifier que l'emplacement actuel existe
# - Vérifier que l'emplacement de destination existe
# - Vérifier que la quantité à déplacer est supérieure à 0
# - Vérifier que la quantité à déplacer est inférieure ou egal la quantité en stock
# - Creer une transaction de sortie pour l'emplacement d'origine
# - Creer une transaction d'entrée pour l'emplacement de destination
# - Mettre à jour la quantité en stock - table stock_details
# - Mettre à jour le statut de l'emplacement d'origine si nécessaire
# - Mettre à jour le statut de l'emplacement de destination
# - Mettre à jour l'emplacement par défaut de l'article si indiqué par l'utilisateur

# La transaction doit etre de type "INV" - Inventaire
#
# Les mise a jours de stock sont traitées dans la fonction update_stock de l'exercice 1

# Validation pre-transfert
# Retourne true si les paramètres sont valides, sinon retourne un tableau d'erreurs
def validate_location_transfer(product_id, from_location_id, to_location_id, quantity)
  err = []
  err << 'Article invalide' unless Product.exists?(product_id)
  err << 'Emplacement d\'origine invalide' unless Location.exists?(from_location_id)
  err << 'Emplacement de destination invalide' unless Location.exists?(to_location_id)
  err << 'La quantité à déplacer doit être supérieure à 0' if quantity <= 0
  err << 'La quantité à déplacer doit être inférieure ou egal à la quantité en stock' if quantity > Product.find(product_id).quantity

  err.empty? ? true : err
end

# change_default_location est un boolean qui indique si l'emplacement par défaut de l'article doit être changé
# Retourne true si les transactions sont valides, sinon retourne un tableau d'erreurs
def create_transfer_transaction(product_id, from_location_id, to_location_id, quantity, change_default_location)
  # On vérifie que les paramètres sont valides
  is_valid = validate_location_transfer(product_id, from_location_id, to_location_id, quantity)
  return is_valid.join(', ') unless is_valid == true

  # On crée une transaction de sortie pour l'emplacement d'origine
  # On crée les transactions - elles mettes à jour les données des tables correspondantes
  transaction_out = Transaction.new(product_id: product_id,
                                    quantity: -quantity,
                                    type: MovementType::INV,
                                    location_id: from_location_id,
                                    description: "Sortie de #{quantity} unités de l'article #{Product.find(product_id).description} de l'emplacement #{Location.find(from_location_id).description}",
                                    created_by: 'User')

  # On crée une transaction d'entrée pour l'emplacement de destination
  transaction_in = Transaction.new(product_id: product_id,
                                   quantity: quantity,
                                   type: MovementType::INV,
                                   location_id: to_location_id,
                                   description: "Entrée de #{quantity} unités de l'article #{Product.find(product_id).description} dans l'emplacement #{Location.find(to_location_id).description}",
                                   created_by: 'User')

  # On met à jour le stock et sauvegarde la transaction de sortie
  # La transaction est validee avant d'etre enregistrée par la fonction save_transaction
  save_transaction(transaction_out)

  # On met à jour le statut de l'emplacement d'origine
  from_location = Location.find(from_location_id)
  from_location.status = 'Disponible' if DetailStock.where(location_id: from_location_id).zero?
  from_location.save

  # Transaction d'entrée
  save_transaction(transaction_in)

  # On met à jour le statut de l'emplacement de destination
  to_location = Location.find(to_location_id)
  to_location.status = 'Non disponible'
  to_location.save

  # On met à jour l'emplacement par défaut de l'article
  return if change_default_location == false

  product = Product.find(product_id)
  product.default_location_id = to_location_id
  product.save
end

# Pour le contexte, nous reprenons la liste ordres d'achats ouverts de l'exercice 3.
# Dans ce fichier, nous allons traiter la validation d'une recepion d'achat ainsi que la sauvegarde de l'achat dans la base de données.
# Les modeles et tables sont identiques à l'exercice 3 et ne seront pas repris ici, a l'exception de la table orders_details qui contient maintenant une date de reception.
# - Les models ReceptionHeader et ReceptionDetail sont definis dans les fichiers reception_header.rb et reception_detail.rb sous exercice_4/models sous forme de migrations ActiveRecord.
# Les validations sont les suivantes:
# - L'achat doit être enregistré dans la base de données
# - L'achat doit être ouvert
# - La quantité reçue doit être supérieure à 0
# - La date de réception doit être renseignée
# - L'article doit exister

# Apres validation de la réception, la ligne d'achat doit être mis à jour avec la quantité reçue
# Si la quantité reçue est égale à la quantité commandée, le statut doit être mis à jour en "Cloturé"
# Si la quantité reçue est inférieure à la quantité commandée, le statut doit être mis à jour en "Partiellement reçu"
# Si la quantité reçue est supérieure à la quantité commandée, le statut doit être mis à jour en "Surplus"
# Une transaction doit être utilisée pour garantir l'intégrité des données
# La transaction créera un mouvement de stock pour la quantité reçue

# Si toutes les lignes d'un ordre d'achat sont cloturées, l'ordre d'achat doit être cloturé
#
# Pour eviter les incoherences, Turbo, ActionCable et Redis peuvent être utilisés pour mettre à jour les données en temps réel

# Validation de la réception d'un achat
def validate_reception_purchase_order(order_detail)
  err = []
  err << 'Ordre d\'achat invalide' if order_detail.nil?
  err << 'Ordre d\'achat inexistant' unless Order.exists?(order_detail.order_id)
  err << 'L\'achat doit être ouvert' unless order_detail.status == 'Ouvert'
  err << 'La quantité reçue doit être supérieure à 0' if order_detail.quantity_received <= 0
  err << 'La date de réception doit être renseignée' if order_detail.reception_date.nil?
  err << 'L\'article doit exister' unless Product.exists?(order_detail.product_id)

  err.empty? ? true : err
end

# Sauvegarde de la réception d'un achat
def save_purchase_order(order_detail, provider_shipping_number, reception_date)
  # On vérifie que l'achat est valide
  is_valid = validate_reception_purchase_order(order_detail)
  raise isValid.join(', ') unless is_valid == true

  raise 'Le numéro de suivi du fournisseur doit être renseigné' if provider_shipping_number.nil?
  raise 'La date de réception doit être renseignée' if reception_date.nil?

  # On sanitize les paramètres
  provider_shipping_number = ActiveRecord::Base.sanitizse_sql(provider_shipping_number)
  reception_date = ActiveRecord::Base.sanitizse_sql(reception_date)

  # On met à jour la ligne d'achat
  order_detail.status = 'Cloturé' if order_detail.quantity_received == order_detail.ordered_quantity
  order_detail.status = 'Partiellement reçu' if order_detail.quantity_received < order_detail.ordered_quantity
  order_detail.status = 'Surplus' if order_detail.quantity_received > order_detail.quantity

  # On crée une transaction pour garantir l'intégrité des données
  transaction = Transaction.new(product_id: order_detail.product_id,
                                quantity: order_detail.quantity_received,
                                type: MovementType::RCPT,
                                location_id: order_detail.product.default_location_id,
                                description: "Réception d'achat de #{order_detail.quantity_received} unités de l'article #{order_detail.product.description}",
                                created_by: 'User')

  # On crée le bon de réception
  reception_header = ReceptionHeader.new(provider_id: order_detail.order_header.provider_id,
                                         provider_shipping_number: provider_shipping_number,
                                         reception_date: reception_date,
                                         status: 'Reçu',
                                         created_by: 'User')
  # On crée le détail de réception
  reception_detail = ReceptionDetail.new(reception_header: reception_header,
                                         order_header: order_detail.order_header,
                                         order_detail: order_detail,
                                         received_quantity: order_detail.quantity_received,
                                         created_by: 'User')

  # On verifie si toutes les lignes de l'achat sont cloturées
  # Si c'est le cas, on cloture l'achat
  order_detail.order_header.status = 'Cloturé' if order_detail.order_header.order_details.all? { |od| od.status == 'Cloturé' }

  # On sauvegarde les données
  order_detail.save
  reception_header.save
  reception_detail.save
  save_transaction(transaction)
end

class OrderHeader < ApplicationRecord
  belongs_to :provider
  has_many :order_details
end

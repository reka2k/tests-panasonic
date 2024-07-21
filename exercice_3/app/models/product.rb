class Product < ApplicationRecord
  has_many :order_detail
  has_many :order_header, through: :order_detail
end

class Invoice < ApplicationRecord
 belongs_to :merchant
 belongs_to :customer
 has_many :transactions, dependent: :destroy
 has_many :invoice_items, dependent: :destroy
 has_many :items, through: :invoice_items

 validates_presence_of :customer_id
 validates_presence_of :status
 validates_numericality_of :customer_id
end

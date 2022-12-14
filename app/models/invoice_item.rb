class InvoiceItem < ApplicationRecord
 belongs_to :item
 belongs_to :invoice

 validates_presence_of :item_id
 validates_numericality_of :item_id
 validates_presence_of :invoice_id
 validates_numericality_of :invoice_id
 validates_presence_of :quantity
 validates_numericality_of :quantity
 validates_presence_of :unit_price
 validates_numericality_of :unit_price
end

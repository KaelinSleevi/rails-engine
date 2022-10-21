class Merchant < ApplicationRecord
 has_many :items
 has_many :invoices

 validates_presence_of :name

 def self.search_for(search)
  where("name ILIKE ?", "%#{search}%").order(:name).first
 end
end

class Item < ApplicationRecord
 belongs_to :merchant
 has_many :invoice_items, dependent: :destroy
 has_many :invoices, through: :invoice_items

 validates_presence_of :name
 validates_presence_of :description
 validates_presence_of :unit_price
 validates_numericality_of :unit_price

 before_destroy :delete_invoices, prepend: true

  def self.search_by_name(search)
    where("name ILIKE ?", "%#{search}%").order(:name)
  end

  def self.search_by_min_price(price)
    where("unit_price >= ?", price).order(:name)
  end

  def self.search_by_max_price(price)
    where("unit_price <= ?", price).order(:name)
  end

 private

  def delete_invoices
    invoices.each do |invoice|                
      if invoice.invoice_items.count == 1
        Invoice.destroy(invoice.id)
      else
      end
    end
  end
end

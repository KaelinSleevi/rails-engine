class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id

  def self.no_item
      {
        "data": {
          "id": nil,
          "type": "item"
        }
      }
  end
end
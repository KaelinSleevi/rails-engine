class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def self.no_merchant
    {
      "data": {
        "id": nil,
        "type": "merchant"
      }
    }
  end
end

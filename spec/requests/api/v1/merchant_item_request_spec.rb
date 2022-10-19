require 'rails_helper'

describe " Merchant Items API" do
  it "sends a list of the merchant and all their items" do
   id = create(:merchant).id

   get "/api/v1/merchants/#{id}}/items"

   expect(response).to be_successful

   merchant = JSON.parse(response.body, symbolize_names: true)
  end
end
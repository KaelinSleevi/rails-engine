require 'rails_helper'

describe "Merchants API" do
  xit "sends a list of merchants" do

   5.times do 
    Merchant.create(
        name: Faker::Name.name,
    )
   end
    create_list(:merchant, 5)

    get '/api/v1/merchants/search'

    expect(response).to be_successful

    books = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end
end
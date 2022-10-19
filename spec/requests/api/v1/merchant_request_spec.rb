require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do

    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(5)

    merchants[:data].each do |data|
      expect(data[:attributes]).to have_key(:name)
      expect(data[:attributes][:name]).to be_a(String)

      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)

      expect(data).to have_key(:type)
      expect(data[:type]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id
  
    get "/api/v1/merchants/#{id}"
  
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant.count).to eq(1)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)
  end

  it "sends a list of the merchant and all their items" do
    merchant = create(:merchant)
    item1 = Item.create!(name: "Leaf Earrings", description: "It's green", unit_price: 120, merchant_id: merchant.id)
    item2 = Item.create!(name: "Flaower Necklace", description: "Is a flower", unit_price: 880,merchant_id: merchant.id) 
    item3 = Item.create!(name: "Da Bracelet", description: "This is da braclet for you",unit_price: 22240, merchant_id: merchant.id)
    item4 = Item.create!(name: "Toes Ring", description: "Do you like it?",unit_price: 40, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"
 
    expect(response).to be_successful
 
    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data].count).to eq(4)

    items[:data].each do |data|
      expect(data[:attributes]).to have_key(:name)
      expect(data[:attributes][:name]).to be_a(String)

      expect(data[:attributes]).to have_key(:description)
      expect(data[:attributes][:description]).to be_a(String)

      expect(data[:attributes]).to have_key(:unit_price)
      expect(data[:attributes][:unit_price]).to be_a(Float)

      expect(data[:attributes]).to have_key(:merchant_id)
      expect(data[:attributes][:merchant_id]).to be_a(Integer)

      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)

      expect(data).to have_key(:type)
      expect(data[:type]).to be_a(String)
    end
  end
end
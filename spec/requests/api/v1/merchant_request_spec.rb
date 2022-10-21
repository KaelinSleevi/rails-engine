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

  it "always return an array of data, even if one or zero resources are found" do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(0)
    expect(merchants[:data]).to eq([])
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

  it "If the user causes an error it sends a status and error message" do
    get "/api/v1/merchants/39792"
 
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response.successful?).to eq(false)
    
    expect(response.status).to eq(404)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to eq(nil)

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

  it "finds one merchant by search criteria" do
    merchant_1 = Merchant.create!(name: "Kaelin")
    merchant_2 = Merchant.create!(name: "Elizabeth")

    get "/api/v1/merchants/find?name=Kae"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)

    expect(Merchant.search_for("Kae")).to eq(merchant_1)
  end

  it "returns null object if no match" do
    merchant_1 = Merchant.create!(name: "Kaelin")
    merchant_2 = Merchant.create!(name: "Elizabeth")

    get "/api/v1/merchants/find?name="

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id].to_i).to be_a(Integer)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)
  end
end
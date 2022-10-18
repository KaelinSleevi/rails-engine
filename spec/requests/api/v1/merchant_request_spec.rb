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

  xit "can get one merchant by its id" do
    id = create(:merchant).id
  
    get "/api/v1/books/#{id}"
  
    merchant = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful

    merchant[:data].each do |data|
      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)


    end
  end
end
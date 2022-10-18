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
    end
  end
end
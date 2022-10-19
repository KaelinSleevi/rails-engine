require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do

    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(5)

    items[:data].each do |data|

      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)

      expect(data).to have_key(:type)
      expect(data[:type]).to be_a(String)
    end
  end

  it "can get one items by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"
  
    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item.count).to eq(1)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_a(String)
  end
end
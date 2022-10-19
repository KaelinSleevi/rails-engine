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

  it "can create a new item" do
   item_params = ({
                   name: 'Leaf Earrings',
                   description: 'its pretty and green',
                   unit_price: 12496,
                   merchant_id: 1
                 })
   headers = {"CONTENT_TYPE" => "application/json"}
 
   # We include this header to make sure that these params are passed as JSON rather than as plain text
   post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
   created_item = Item.last
 
   expect(response).to be_successful
   expect(created_item.name).to eq(item_params[:name])
   expect(created_item.description).to eq(item_params[:description])
   expect(created_item.unit_price).to eq(item_params[:unit_price])
   expect(created_item.merchant_id).to eq(item_params[:merchant_id])
 end
end
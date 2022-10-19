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
   merchant = create(:merchant)

   item_params = ({
                   name: 'Leaf Earrings',
                   description: 'its pretty and green',
                   unit_price: 124.96,
                   merchant_id: merchant.id
                 })
   headers = {"CONTENT_TYPE" => "application/json"}
 
   post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
   
   created_item = Item.last
 
   expect(response).to be_successful

   expect(created_item.name).to eq(item_params[:name])
   expect(created_item.description).to eq(item_params[:description])
   expect(created_item.unit_price).to eq(item_params[:unit_price])
   expect(created_item.merchant_id).to eq(item_params[:merchant_id])
 end

 it 'can delete an item' do
  merchant = create(:merchant)
  item = create(:item)

  expect(Item.count).to eq(1)

  delete "/api/v1/items/#{item.id}"

  expect(response).to be_successful
  expect(Item.count).to eq(0)
  expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
 end

 it 'can update an item' do
  merchant = create(:merchant)
  id = create(:item).id

  previous_name = Item.last.name

  item_params = { name: "Silver Ting" }
  headers = {"CONTENT_TYPE" => "application/json"}

  patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
  item = Item.find_by(id: id)

  expect(response).to be_successful
  expect(item.name).to_not eq(previous_name)
  expect(item.name).to eq("Silver Ting")
 end
end
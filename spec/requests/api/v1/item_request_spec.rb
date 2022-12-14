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

     expect(data).to have_key(:attributes)
     expect(data[:attributes]).to be_a(Hash)

     expect(data[:attributes]).to have_key(:name)
     expect(data[:attributes][:name]).to be_a(String)

     expect(data[:attributes]).to have_key(:description)
     expect(data[:attributes][:description]).to be_a(String)

     expect(data[:attributes]).to have_key(:unit_price)
     expect(data[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it "always return an array of data, even if one or zero resources are found" do
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(0)
    expect(items[:data]).to eq([])
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

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_a(Hash)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end

  it "If the user causes an error it sends a status and error message" do
    get "/api/v1/items/314159265359"
 
    item = JSON.parse(response.body, symbolize_names: true)

    expect(response.successful?).to eq(false)
    
    expect(response.status).to eq(404)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to eq(nil)

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

 it "return an error if any attribute of that item is missing" do
  merchant = create(:merchant)

  item_params = ({
                  name: 'Leaf Earrings',
                  unit_price: 124.96,
                  merchant_id: merchant.id
                })
  headers = {"CONTENT_TYPE" => "application/json"}

  post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
  
  expect(response.successful?).to eq(false)
    
  expect(response.status).to eq(404)
 end

 it 'can delete an item' do
  merchant = create(:merchant)
  item = create(:item)

  expect(Item.count).to eq(1)

  delete "/api/v1/items/#{item.id}"
 
  expect(response).to be_successful
  expect(Item.count).to eq(0)
  expect(response.status).to eq(204)
  expect(response.body).to eq("")
  expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
 end

 it 'can delete the invoice if the associated item is the only existing item' do
  merchant = create(:merchant)

  item1 = create(:item)
  item2 = create(:item)

  invoice1 = create(:invoice)
  invoice2 = create(:invoice)

  invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, unit_price: item1.unit_price, quantity: 12)
  invoice_item2 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice2.id, unit_price: item1.unit_price, quantity: 2938)
  invoice_item3 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice2.id, unit_price: item2.unit_price, quantity: 3343)

  expect(Item.count).to eq(2)
  expect(Invoice.count).to eq(2)

  expect{ delete "/api/v1/items/#{item1.id}" }.to change(Item, :count).by(-1)

  expect(invoice1.items).to eq([])

  expect{Item.find(item1.id)}.to raise_error(ActiveRecord::RecordNotFound)
  expect{Invoice.find(invoice1.id)}.to raise_error(ActiveRecord::RecordNotFound)
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

 it "can not update without a valid id" do
  merchant = create(:merchant)

  item_params = { name: "Silver Ting" }
  headers = {"CONTENT_TYPE" => "application/json"}

  patch "/api/v1/items/93947", headers: headers, params: JSON.generate({item: item_params})

  expect(response.successful?).to eq(false)
  expect(response.status).to eq(404)
 end

 it "can not update without a valid merchant_id" do
  id = create(:item).id

  item_params = { merchant_id: 67594}
  headers = {"CONTENT_TYPE" => "application/json"}

  patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
  item = Item.find_by(id: id)
 
  expect(response.successful?).to eq(false)
  expect(response.status).to eq(400)
 end

 it "can not update without a valid entry (name, description)" do
  merchant = create(:merchant)
  id = create(:item).id

  previous_name = Item.last.name

  item_params = { name: " " }
  headers = {"CONTENT_TYPE" => "application/json"}

  patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
  item = Item.find_by(id: id)

  expect(response.successful?).to eq(false)
  expect(response.status).to eq(400)
 end

 it "sends a list of the item and all its merchants" do
    item = create(:item)
    merchant1 = Merchant.create!(name: "Keanu Reeves")
    merchant2 = Merchant.create!(name: "Boba Fett") 
    merchant3 = Merchant.create!(name: "Nick Miller")

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    expect(merchants[:data][:attributes]).to have_key(:name)
    expect(merchants[:data][:attributes][:name]).to be_a(String)

    expect(merchants[:data]).to have_key(:id)
    expect(merchants[:data][:id]).to be_a(String)

    expect(merchants[:data]).to have_key(:type)
    expect(merchants[:data][:type]).to be_a(String)
  end

  it "finds all items by search criteria" do
    merchant = create(:merchant)
    item1 = merchant.items.create!(name: "Boba Statue", description: "Lorem ipsum", unit_price: 1)
    item2 = merchant.items.create!(name: "Bro Cap", description: "We love it", unit_price: 2)
    item3 = merchant.items.create!(name: "This is an item", description: "No cap", unit_price: 3)
    item4 = merchant.items.create!(name: "I swear", description: "I did swear, it means I promise", unit_price: 3)

    get "/api/v1/items/find_all?name=a"

    items_list = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
   
    items_list[:data].each do |data|
      expect(data[:attributes]).to have_key(:name)
      expect(data[:attributes][:name]).to be_a(String)
  
      expect(data[:attributes]).to have_key(:description)
      expect(data[:attributes][:description]).to be_a(String)
  
      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)
  
      expect(data).to have_key(:type)
      expect(data[:type]).to be_a(String)
    end
  end

  it 'will not find items without the correct search criteria' do
    merchant = create(:merchant)
    item1 = merchant.items.create!(name: "Boba Statue", description: "Lorem ipsum", unit_price: 1)
    item2 = merchant.items.create!(name: "Bro Cap", description: "We love it", unit_price: 2)
    item3 = merchant.items.create!(name: "This is an item", description: "No cap", unit_price: 3)
    item4 = merchant.items.create!(name: "I swear", description: "I did swear, it means I promise", unit_price: 3)

    get "/api/v1/items/find_all?name=Z"

    items_list = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)

    expect(items_list[:data]).to eq([])

    items_list[:data].each do |data|
      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)
  
      expect(data).to have_key(:type)
      expect(data[:type]).to be_a(String)
    end
  end

  it 'finds all items by search criteria(max_price)' do
    merchant = create(:merchant)
    item1 = merchant.items.create!(name: "Boba Statue", description: "Lorem ipsum", unit_price: 123)
    item2 = merchant.items.create!(name: "Bro Cap", description: "We love it", unit_price: 289)
    item3 = merchant.items.create!(name: "This is an item", description: "No cap", unit_price: 356)
    item4 = merchant.items.create!(name: "I swear", description: "I did swear, it means I promise", unit_price: 334)

    get "/api/v1/items/find_all?max_price=300"

    items_list = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
  end

  it 'finds all items by search criteria(min_price)' do
    merchant = create(:merchant)
    item1 = merchant.items.create!(name: "Boba Statue", description: "Lorem ipsum", unit_price: 123)
    item2 = merchant.items.create!(name: "Bro Cap", description: "We love it", unit_price: 289)
    item3 = merchant.items.create!(name: "This is an item", description: "No cap", unit_price: 356)
    item4 = merchant.items.create!(name: "I swear", description: "I did swear, it means I promise", unit_price: 334)

    get "/api/v1/items/find_all?min_price=150"

    items_list = JSON.parse(response.body, symbolize_names: true)
    
    expect(response.status).to eq(200)
  end
end
require 'rails_helper'

 RSpec.describe 'Items API' do
   it "can update an existing Item" do
     merchant = create(:merchant)
     id = create(:item, merchant: merchant).id
     previous_name = Item.last.name
     previous_description = Item.last.description
     previous_unit_price = Item.last.unit_price
     item_params = {name: "Awesome Sauce", description: "Tomato Sauce", unit_price: 29.99, merchant_id: merchant.id}
     headers = {"CONTENT_TYPE" => "application/json"}

     patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

     item = Item.find_by(id: id)

     expect(response).to be_successful
     expect(item.name).to_not eq(previous_name)
     item_data = JSON.parse(response.body, symbolize_names: true)
     expect(response.status).to eq(200)

     expect(item_data[:data]).to have_key(:id)
     expect(item_data[:data]).to have_key(:type)
     expect(item_data[:data]).to have_key(:attributes)
     expect(item_data[:data][:attributes]).to have_key(:name)
     expect(item_data[:data][:attributes]).to have_key(:description)
     expect(item_data[:data][:attributes]).to have_key(:unit_price)
   end

   it "can create a new Item" do
     merchant = create(:merchant)
     item_params = {name: "Awesome Sauce", description: "Tomato Sauce", unit_price: 29.99, merchant_id: merchant.id}
     headers = {"CONTENT_TYPE" => "application/json"}

     post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
     created_item = Item.last

     expect(response.status).to eq(201)

     item_data = created_item = JSON.parse(response.body, symbolize_names: true)

     expect(item_data[:data]).to have_key(:id)
     expect(item_data[:data]).to have_key(:type)
     expect(item_data[:data]).to have_key(:attributes)
     expect(item_data[:data][:attributes]).to have_key(:name)
   end

   it "can destroy an Item" do
     merchant = create(:merchant)
     item = create(:item, merchant: merchant)

     expect(Item.count).to eq(1)
     expect{delete "/api/v1/items/#{item.id}"}.to change(Item, :count).by(-1)


     expect(Item.count).to eq(0)
     expect(response.status).to eq(204)


     expect(response).to be_success
     expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
   end

   it "can send one item" do
     merchant = create(:merchant)
     item = create(:item, merchant: merchant)

     get "/api/v1/items/#{item.id}"

     expect(response).to be_successful
     expect(response.status).to eq(200)

     item = JSON.parse(response.body, symbolize_names: true)

     expect(item[:data]).to have_key(:id)
     expect(item[:data]).to have_key(:type)
     expect(item[:data]).to have_key(:attributes)
     expect(item[:data][:attributes]).to have_key(:name)
     expect(item[:data][:attributes]).to have_key(:description)
     expect(item[:data][:attributes]).to have_key(:unit_price)
   end

   it "can send all items" do
     merchant = create(:merchant)
     create_list(:item, 3, merchant: merchant)

     get "/api/v1/items"

     expect(response).to be_successful
     expect(response.status).to eq(200)

     items = JSON.parse(response.body, symbolize_names: true)

     expect(items[:data].count).to eq(3)

     items[:data].each do |item|
       expect(item).to have_key(:id)
       expect(item).to have_key(:type)
       expect(item).to have_key(:attributes)
       expect(item[:attributes]).to have_key(:name)
       expect(item[:attributes]).to have_key(:description)
       expect(item[:attributes]).to have_key(:unit_price)
     end
   end
     it "can send the items merchant by ID" do
       merchant = create(:merchant)
       item = create(:item, merchant: merchant)

       get "/api/v1/items/#{item.id}/merchant"

       expect(response).to be_successful
       expect(response.status).to eq(200)

       items_merchant = JSON.parse(response.body, symbolize_names: true)

       expect(items_merchant[:data]).to have_key(:id)
       expect(items_merchant[:data]).to have_key(:type)
       expect(items_merchant[:data]).to have_key(:attributes)
       expect(items_merchant[:data][:attributes]).to have_key(:name)
   end
 end

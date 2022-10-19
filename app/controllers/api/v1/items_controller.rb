class Api::V1::ItemsController < ApplicationController

 def index
  render json: ItemSerializer.new(Item.all)
 end

 def show
  item = Item.find(params[:id])
  render json: ItemSerializer.new(item)
 end

 def create
  item = Item.new(item_params)
  if item.save
   render json: ItemSerializer.new(item)
  else
   render status: 404
  end
 end
 
 private

 def item_params
  params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
 end
end
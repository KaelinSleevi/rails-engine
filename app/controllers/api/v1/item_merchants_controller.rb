class Api::V1::ItemMerchantsController < ApplicationController

 def index
   merchants = Item.find(params[:item_id]).merchant
   render json: MerchantSerializer.new(merchants)
  end
end
class Api::V1::MerchantsController < ApplicationController

 def index
  render json: MerchantSerializer.new(Merchant.all)
 end

 def show
   if Merchant.exists?(params[:id])
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
   else 
    render json: MerchantSerializer.no_merchant, status: 404
   end
 end
end
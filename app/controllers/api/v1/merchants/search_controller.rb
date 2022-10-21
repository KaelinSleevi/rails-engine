class Api::V1::Merchants::SearchController < ApplicationController

 def find
  merchant = Merchant.search_for(params[:name])
    if merchant.nil?
      render json: {data: {error: :null}}
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
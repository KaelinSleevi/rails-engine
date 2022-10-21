class Api::V1::Merchants::SearchController < ApplicationController

 def find
  merchant = Merchant.search_for(params[:name])
    if merchant.nil?
      render json: {data: {error: :null}}, status: 200
    else
      render json: MerchantSerializer.new(merchant), status: 200
    end
  end
end
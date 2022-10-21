class Api::V1::Items::SearchController < ApplicationController

 def find_all
  items = Item.search_by_name(params[:name])
    if items.nil?
      render json: {data: {error: :null}}
    else
      render json: ItemSerializer.new(items)
    end
  end
 end
class Api::V1::Items::SearchController < ApplicationController

def find_all
  items = Item.search_by_name(params[:name])
    if params[:name] && params[:name].empty? == false
      render json: ItemSerializer.new(Item.search_by_name(params[:name]))
    elsif params[:min_price] && params[:min_price].empty? == false
      render json: ItemSerializer.new(Item.search_by_min_price(params[:min_price]))
    elsif params[:max_price] && params[:max_price].empty? == false
      render json: ItemSerializer.new(Item.search_by_max_price(params[:max_price]))
    else 
      render status: 404
    end 
  end
end
 
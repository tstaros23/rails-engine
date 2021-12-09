class Api::V1::ItemsController < ApplicationController
  def create
    created_item = Item.create(item_params)
    render json: ItemSerializer.new(created_item), status: :created
  end

  def update
    item = Item.find(params[:id])
    updated_item = Item.update(item.id, item_params)
    render json: ItemSerializer.new(updated_item)
  end

  def destroy
    Item.delete(params[:id])
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end

class Api::V1::Merchants::SearchController < ApplicationController
  # def most_items
  #   if params[:quantity].present?
  #     merchants = Merchant.most_items(params[:quantity])
  #     render json: MerchantSerializer.new(merchants)
  #   else
  #     render json: {error: {details: "Bad request"}}, status: 400
  #   end
  # end

  def show
     = Merchant.search_for_names(params[:name])
    return render json: {data: {}} if merchant.nil?
    render json: MerchantSerializer.new(merchant)
  end
end

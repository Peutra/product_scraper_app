class ProductsController < ApplicationController

  def query
  end

  def geturl
    @product_url = params_product_url
  end

  private

  def params_product_url
    params.require(:product_url).permit(:url)
  end

end

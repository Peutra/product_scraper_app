class PagesController < ApplicationController

  def home
  end

  def geturl
    @product_url = params_product_url
    binding.pry
  end

  private

  def params_product_url
    params.require(:product_url).permit(:url)
  end

end

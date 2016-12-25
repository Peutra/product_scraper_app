class ProductsController < ApplicationController

  include ERB::Util

  def query
  end

  def geturl
    @product_url = params_product_url
    get_response(@product_url['url'])
  end

  def get_response(url)
    if encoded_url = url_encode(url)
      response = DiffbotQueryService.new.get_response(url)
    end
  end

  private

  def params_product_url
    params.require(:product_url).permit(:url)
  end

end

class ProductsController < ApplicationController

  include ERB::Util

  before_filter :load_product
  after_filter :save_product

  def query
    @product
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

  def reset_product
    @product = Hash.new
    @products_count = 0
    session[:products] = Hash.new
    session[:products_count] = 0
    render 'products/query'
  end

  private

  def params_product_url
    params.require(:product_url).permit(:url)
  end

  def load_product
    @product = session[:products] || Hash.new
    @count = session[:products_count] || 0
  end

  def save_product
    session[:products_count] += 1
    session[:products] = @product
  end

end

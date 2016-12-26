class ProductsController < ApplicationController

  include ERB::Util

  before_filter :load_product, only: [:query]
  after_filter :save_product, only: [:get_response]

  def query
  end

  def geturl
    @product_url = params_product_url
    get_response(@product_url['url'])
  end

  def get_response(url)
    if encoded_url = url_encode(url)
      if response = DiffbotQueryService.new.get_response(url)
          save_product(response)
          redirect_to :action => 'query'
      end
    end
  end

  def reset_products
    session.delete(:products)
    session.delete(:products_count)
    redirect_to :action => 'query'
  end

  private

  def params_product_url
    params.require(:product_url).permit(:url)
  end

  def load_product
    session[:products] = Hash.new if !session[:products]
    session[:products_count] = 0 if !session[:products_count]
  end

  def save_product(response)
    session[:products_count] += 1
    session[:products][session[:products_count]] = response
  end

end

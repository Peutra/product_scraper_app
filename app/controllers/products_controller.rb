class ProductsController < ApplicationController

  include ERB::Util

  before_filter :load_product, only: [:query]

  def query
  end

  def geturl
    @product_url = params_product_url
    if valid?(@product_url['url'])
      get_response(@product_url['url'])
    else
      flash[:alert] = 'This url does not feel valid'
      redirect_to :action => 'query'
    end
  end

  # DiffbotQueryService is... a service that can be found in app/services
  def get_response(url)
    if response = DiffbotQueryService.new.get_response(url)
        save_product(response)
        redirect_to :action => 'query'
      else
        flash[:alert] = 'Something went wrong processing your request'
        redirect_to :action => 'query'
    end
  end

  def save_products
    batch = Product.current_batch
    session[:products].each do |product|
      new_product = Product.create(
                      title: product[1]['title'],
                      price: product[1]['price'],
                      currency: product[1]['currency'],
                      image: product[1]['image'],
                      description: product[1]['description'],
                      url: product[1]['url'],
                      brand: product[1]['brand'],
                      batch: batch
                   )
    end
    session_products_delete
    redirect_to :action => 'index'
  end

  def index
    @number_of_batches = Product.number_of_batches
    @reverse_range_of_batches = (@number_of_batches..1)
    @products = Product.all
  end

  def batch_creation_date(number)
    Product.batch_creation_date(number)
  end
  helper_method :batch_creation_date

  def edit
    @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(params_product)
      redirect_to controller: 'products', action: 'show', id: @product.id
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to request.referrer
  end

  def reset_products
    session_products_delete
    redirect_to :action => 'query'
  end

  private

  def params_product_url
    params.require(:product_url).permit(:url)
  end

  def params_product
    params.require(:product).permit(:url, :title, :description, :currency,
                                    :image, :price)
  end

  def load_product
    session[:products] = Hash.new if !session[:products]
    session[:products_count] = 0 if !session[:products_count]
  end

  def save_product(response)
    session[:products_count] += 1
    session[:products][session[:products_count]] = response
  end

  def session_products_delete
    session.delete(:products)
    session.delete(:products_count)
  end

  def valid?(url)
    PublicSuffix.valid?(url_encode(url))
  end

end

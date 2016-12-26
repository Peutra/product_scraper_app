class Product < ActiveRecord::Base
  # To do validations

  def self.get_current_batch
    Product.maximum('batch') ? Product.maximum('batch') + 1 : 1
  end
end

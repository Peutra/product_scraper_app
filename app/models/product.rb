class Product < ActiveRecord::Base
  # To do : validations

  def self.get_current_batch
    Product.maximum('batch') ? Product.maximum('batch') + 1 : 1
  end

  def self.get_number_of_batches
    get_current_batch - 1
  end

  def self.products_with_batch(number)
    Product.where(batch: number)
  end

  def self.batch_creation_date(number)
    products_with_batch(number).first.created_at
  end

end

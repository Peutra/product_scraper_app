class Product < ActiveRecord::Base
  # To do : validations

  def self.current_batch
    Product.maximum('batch') ? Product.maximum('batch') + 1 : 1
  end

  def self.number_of_batches
    current_batch - 1
  end

  def self.products_with_batch(number)
    Product.where(batch: number)
  end

  def self.batch_creation_date(number)
    if products_with_batch(number).first
      return products_with_batch(number).first.created_at
    else
      return false
    end
  end

end

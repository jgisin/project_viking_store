class Product < ActiveRecord::Base

  validates :name, :price, :sku, presence: true

  def self.new_products(n)
    Product.all.where("created_at BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()").count
  end


  def self.total
    Product.select("name").distinct.count
  end


  def self.times_ordered(product_id)
    # products to order_contents to orders, make sure checkout date is not null
    Product.joins("JOIN order_contents ON products.id = order_contents.product_id")
           .joins("JOIN orders ON orders.id = order_contents.order_id")
           .where("orders.checkout_date IS NOT NULL AND products.id = #{product_id}")
           .count("order_contents.product_id")
  end

#   SELECT count(oc.product_id) FROM products p
# JOIN order_contents oc ON oc.product_id = p.id
# JOIN orders o ON o.id = oc.order_id
# WHERE o.checkout_date IS NOT NULL
# AND p.id = 7;




  def self.number_of_carts(product_id)
    # products to order_contents to orders, make sure checkout date IS null
    Product.joins("AS p JOIN order_contents oc ON oc.product_id = p.id")
           .joins("JOIN orders o ON o.id = oc.order_id")
           .where("o.checkout_date IS NULL AND p.id = #{product_id}")
           .count("oc.product_id")
  end


end

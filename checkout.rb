class Product
  attr_reader :code, :name, :price, :discount_type, :discount_value

  def initialize(code, name, price, discount_type = nil, discount_value = nil)
    @code = code
    @name = name
    @price = price
    @discount_type = discount_type
    @discount_value = discount_value
  end
end

class Checkout
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @cart = Hash.new(0)
    @valid_code = @pricing_rules.map(&:code)
  end

  def scan(item_code)
    return unless is_valid_code?(item_code)
    @cart[item_code] += 1
  end

  def total
    total_price = 0

    @cart.each do |item_code, quantity|
      product = find_product(item_code)
      total_price += calculate_item_price(product, quantity)
    end

    '%.2f' % total_price
  end

  private

  def find_product(item_code)
    @pricing_rules.find { |product| product.code == item_code }
  end

  def is_valid_code?(item_code)
    @valid_code.include?(item_code)
  end

  def calculate_item_price(product, quantity)
    case product.discount_type
    when '2_for_1'
      (quantity / 2 + quantity % 2) * product.price
    when 'bulk'
      if quantity >= product.discount_value
        quantity * product.price * (1 - 0.05)
      else
        quantity * product.price
      end
    else
      quantity * product.price
    end
  end
end

# Sample data
pricing_rules = [
  Product.new("VOUCHER", "Voucher", 5.00, "2_for_1"),
  Product.new("TSHIRT", "T-Shirt", 20.00, "bulk", 3),
  Product.new("MUG", "Coffee Mug", 7.50)
]

# Usage
co = Checkout.new(pricing_rules)
co.scan("VOUCHER")
co.scan("TSHIRT")
co.scan("MUG")

# co.scan("VOUCHER")
# co.scan("TSHIRT")
# co.scan("VOUCHER")

# co.scan("TSHIRT")
# co.scan("TSHIRT")
# co.scan("TSHIRT")
# co.scan("VOUCHER")
# co.scan("TSHIRT")

# co.scan("VOUCHER")
# co.scan("TSHIRT")
# co.scan("VOUCHER")
# co.scan("VOUCHER")
# co.scan("MUG")
# co.scan("TSHIRT")
# co.scan("TSHIRT")


price = co.total
puts "Total: #{price} $"

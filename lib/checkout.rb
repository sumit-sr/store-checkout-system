class Checkout
  load 'lib/product.rb'
  load 'lib/offer.rb'
  load 'lib/order.rb'

  @@offers = []
  @@order = {}

  # It will setup all basic required variables
  def initialize(offers)
    if data_exist?(offers)
      @@offers = offers
      @@order = Order.new_order
    end
  end

  def scan(item)
    if valid_item_code?(item.to_sym)
      insert_item(item.to_sym)
    else
      puts "Invalid product code!"
    end
  end

  def insert_item(item)
    @@order[:items][item] = { quantity: 0 } if @@order[:items][item].nil?
    @@order[:items][item][:quantity] += 1
    @@order[:items][item][:price] = @product[:price]
  end

  def total
    @@order[:items].map do |item_code, detail|
      product =Product::PRODUCTS[item_code]
      offer = @@offers[item_code]
      if data_exist?(offer) && offer[:buy_min] <= detail[:quantity]
        apply_offer(product, offer, detail)
      else
        add_buying_price_for_items(product, offer, product[:price])
        add_in_total_price(detail[:quantity], product[:price])
      end
    end
    remove_buying_amount_for_free_item
    evaluate_total
    puts "$#{@@order[:total]}"
    return @@order[:total]
  end

  def apply_offer(product, offer, detail)
    if offer[:free_item_rule].nil?
      if offer[:discount_rule][:on_all]
        add_buying_price_for_items(product, offer, offer[:discount_rule][:price])
        add_in_total_price(detail[:quantity], offer[:discount_rule][:price])
      else
        offer_on = detail[:quantity] - offer[:buy_min]
        add_buying_price_for_items(product, offer, offer[:discount_rule][:price])
        add_in_total_price(offer_on, offer[:discount_rule][:price])
        add_in_total_price(offer[:buy_min], product[:price])
      end
    else
      free_product = Product::PRODUCTS[offer[:free_item_rule][:product_code]]
      min_quantity =  offer[:buy_min]
      get_free_quantity = offer[:free_item_rule][:quantity]
      purchasing_quantity = detail[:quantity]
      free_items_quantity = 0
      paying_items_quantity = 0
      remaining =  purchasing_quantity

      if offer[:free_item_rule][:on_all]
        if offer[:free_item_rule][:product_code] == product[:code]
          until remaining <= 0
            paying_items_quantity += 1
            remaining =  remaining-get_free_quantity
            free_items_quantity += get_free_quantity
          end
        else
          paying_items_quantity = purchasing_quantity
          free_items_quantity = purchasing_quantity*get_free_quantity
        end
      else
        until remaining < min_quantity
          remaining =  remaining-min_quantity
          free_items_quantity += get_free_quantity
        end

        if offer[:free_item_rule][:product_code] == product[:code]
          paying_items_quantity = purchasing_quantity-free_items_quantity
        else
          paying_items_quantity = purchasing_quantity
        end
      end
      add_buying_price_for_items(product, offer, product[:price])
      add_in_total_price(paying_items_quantity, product[:price])
      add_in_free_items(free_items_quantity, free_product)
    end
  end

  def remove_buying_amount_for_free_item
    deduct_amount = 0
    @@order[:free_items].map do |item_code, detail|
      item_code = item_code.to_sym
      item_detail = @@order[:items][item_code]
      offer = nil
      @@offers.map do |key, data|
        if data[:code] == item_detail[:offer_code]
          offer = data
        end
      end
      if data_exist?(item_detail)
        paid_for = item_detail[:quantity]
        make_it_free = detail[:quantity]
        if data_exist?(offer)
          if item_detail[:quantity] > offer[:buy_min]
            if paid_for <= make_it_free
              deduct_amount += paid_for*item_detail[:buying_price]
            else
              deduct_amount += make_it_free*item_detail[:buying_price]
            end
          end
        else
          if paid_for <= make_it_free
            deduct_amount += paid_for*item_detail[:buying_price]
          else
            deduct_amount += make_it_free*item_detail[:buying_price]
          end
        end
      end
    end
    @@order[:sub_total] -= deduct_amount
    @@order[:total] = @@order[:sub_total] + @@order[:additional_charges]
  end

  def add_buying_price_for_items(product, offer, discounted_price)
    code = product[:code].to_sym
    @@order[:items][code][:offer_code] = offer[:code] unless offer.nil?
    @@order[:items][code][:buying_price] = discounted_price
  end

  def add_in_total_price(quantity, price)
    @@order[:items_count] += quantity
    @@order[:sub_total] += quantity*price
  end

  def add_in_free_items(free_quantity, product)
    p_code = product[:code].to_sym
    @@order[:free_items][p_code] = {} unless data_exist?(@@order[:free_items][p_code])
    @@order[:free_items][p_code][:quantity] = free_quantity
    @@order[:free_items_count] += free_quantity
  end

  def evaluate_total
    @@order[:additional_charges] = Product::TAX_CHARGES
    @@order[:total] = (@@order[:sub_total] + @@order[:additional_charges]).round(2)
  end

  # Validation check for nil and empty offer list passed during checkout
  def data_exist?(parameter)
    !parameter.nil? && !parameter.empty?
  end

  # Check to verify, whether it's a valid product code or not
  def valid_item_code?(item_code)
    @product = Product::PRODUCTS[item_code]
    (!@product.nil? && !@product.empty?)
  end
end

# puts "Test examples"

# # SKUs Scanned: atv, atv, atv, vga 
# # Total expected: $249.00
# puts "Test 1st:"
# puts "Expected o/p $249"
# co = Checkout.new(Offer::OFFERS)
# %w[atv atv atv vga].map{ |code| co.scan(code) }
# puts "Test result:"
# co.total()
# puts "----------------------------------------"


# # SKUs Scanned: atv, ipd, ipd, atv, ipd, ipd, ipd 
# # Total expected: $2718.95
# puts "Test 2nd:"
# puts "Expected o/p $2718.95"
# co = Checkout.new(Offer::OFFERS)
# %w[atv ipd ipd atv ipd ipd ipd].map{ |code| co.scan(code) }
# puts "Test result:"
# co.total()
# puts "----------------------------------------"

# # SKUs Scanned: mbp, vga, ipd 
# # Total expected: $1949.98
# puts "Test 3rd:"
# puts "Expected o/p $1949.98"
# co = Checkout.new(Offer::OFFERS)
# %w[mbp vga ipd].map{ |code| co.scan(code) }
# puts "Test result:"
# co.total()

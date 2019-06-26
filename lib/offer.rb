class Offer

  OFFERS = { 
             atv: { code: 'AZmx_w', name: '3 for 2 deal on Apple TVs', buy_min: 3,
                  free_item_rule: { quantity: 1, product_code: :atv, on_all: false } },
             ipd: { code: 'isT2Kg', name: 'Super iPad bulk discount', buy_min: 4,
                  discount_rule: { price: 499.99, on_all: true } },
             mbp: { code: 'xjBtMA', name: 'MacBook Pro', buy_min: 1, free_item_rule: { quantity: 1, product_code: :vga, on_all: true } }
           }

  def self.add(details = {})
    OFFERS.merge!(details)
  end
end

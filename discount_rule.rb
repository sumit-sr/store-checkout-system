class DiscountRule

  DISCOUNT_RULES = { '1': { price: 499.99, on_all: true } }

  def self.add(details = {})
    DISCOUNT_RULES.merge!(details)
  end
end

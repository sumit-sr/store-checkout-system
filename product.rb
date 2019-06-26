class Product
  TAX_CHARGES = 0

  PRODUCTS = { ipd: { name: 'Super iPad', price: 549.99, currency: '$', code: :ipd },
               mbp: { name: 'MacBook Pro', price: 1399.99, currency: '$', code: :mbp },
               atv: { name: 'Apple TV', price: 109.50, currency: '$', code: :atv },
               vga: { name: 'VGA adapter', price: 30.00, currency: '$', code: :vga }
             }

  def insert(details = {})
    PRODUCTS.merge!(details)
  end
end

# Use this insert methods, whenever you want to add any new product into the list
# Ex:
# new_product = { swth: { name: 'Smart Watch', price: 300, currency: '$' } }
# Product.insert(new_product)

# When we have Active records:
# Product
# Offer
# Order/Cart has_many items
# Item


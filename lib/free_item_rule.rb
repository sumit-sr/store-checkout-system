class FreeItemRule

  FREE_ITEM_RULES = { 
                      '1': { quantity: 1, product_code: 'atv', on_all: false },
                      '2': { quantity: 1, product_code: 'vga', on_all: true }
                    }

  def self.add(details = {})
    FREE_ITEM_RULES.merge!(details)
  end
end

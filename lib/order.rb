class Order

  def self.new_order
    { sub_total: 0.0, additional_charges: 0.0, total: 0.0, items: {}, free_items: {}, items_count: 0, free_items_count: 0 }
  end
end

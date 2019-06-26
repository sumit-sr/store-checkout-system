require 'spec_helper'
require 'checkout'
RSpec.describe Checkout, "checked out" do
  context "when product is found" do
    it "get the final price" do
      # Dummy product offers

      puts 'Test 1st'
      checkout = Checkout.new(Offer::OFFERS)
      %w[atv atv atv vga].map{ |code| checkout.scan(code) }
      expect(checkout.total).to eq 249.0

      puts 'Test 2nd'
      checkout = Checkout.new(Offer::OFFERS)
      %w[atv ipd ipd atv ipd ipd ipd].map{ |code| checkout.scan(code) }
      expect(checkout.total).to eq 2718.95

      puts 'Test 3rd'
      checkout = Checkout.new(Offer::OFFERS)
      %w[mbp vga ipd].map{ |code| checkout.scan(code) }
      expect(checkout.total).to eq 1949.98
    end
  end
end

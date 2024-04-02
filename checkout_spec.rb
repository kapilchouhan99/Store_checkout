require_relative 'checkout'
require 'rspec'

RSpec.describe Checkout do
  let(:pricing_rules) do
    [
      Product.new("VOUCHER", "Voucher", 5.00, "2_for_1"),
      Product.new("TSHIRT", "T-Shirt", 20.00, "bulk", 3),
      Product.new("MUG", "Coffee Mug", 7.50)
    ]
  end

  describe '#scan' do
    let(:co) { Checkout.new(pricing_rules) }

    context "when valid code is scan" do
      it 'should add the item to the cart' do
        co.scan("VOUCHER")
        expect(co.instance_variable_get(:@cart)["VOUCHER"]).to eq(1)
      end
    end

    context "when invalid code is scan" do
      it 'should not add the item to the cart' do
        co.scan("VOU")
        expect(co.instance_variable_get(:@cart)["VOU"]).to eq(0)
      end
    end
  end

  describe '#total' do
    let(:co) { Checkout.new(pricing_rules) }

    shared_examples 'correct total price' do |items, expected_total|
      it "for items #{items} should be #{expected_total}" do
        items.each { |item| co.scan(item) }
        expect(co.total).to eq(expected_total)
      end
    end

    include_examples 'correct total price', ['VOUCHER', 'TSHIRT', 'MUG'], '32.50'
    include_examples 'correct total price', ['VOUCHER', 'TSHIRT', 'VOUCHER'], '25.00'
    include_examples 'correct total price', ['TSHIRT', 'TSHIRT', 'TSHIRT', 'VOUCHER', 'TSHIRT'], '81.00'
    include_examples 'correct total price', ['VOUCHER', 'TSHIRT', 'VOUCHER', 'VOUCHER', 'MUG', 'TSHIRT', 'TSHIRT'], '74.50'
  end
end
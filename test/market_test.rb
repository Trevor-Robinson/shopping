require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/vendor'
require './lib/market'
require 'mocha/minitest'

class MarketTest < Minitest::Test
  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @vendor3.stock(@item1, 65)
  end
  def test_it_exists_and_has_attributes
    market = Market.new("South Pearl Street Farmers Market")
    assert_instance_of Market, market
    assert_equal "South Pearl Street Farmers Market", market.name
    assert_equal [], market.vendors
  end

  def test_it_can_add_vendors
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    assert_equal [@vendor1], market.vendors
  end

  def test_it_can_return_vendor_names
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    assert_equal ["Rocky Mountain Fresh", "Ba-Nom-a-Nom"], market.vendor_names
  end

  def test_it_can_return_vendors_that_sell
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)
    assert_equal [@vendor1, @vendor3], market.vendors_that_sell(@item1)
  end

  def test_it_can_return_total_inventory
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    market.add_vendor(@vendor3)
    assert_equal ({@item1 => {quantity: 100, vendors: [@vendor1, @vendor3]}, @item2 => {quantity: 7, vendors: [@vendor1]}}), market.total_inventory
  end

  def test_it_can_return_overstocked_items
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    market.add_vendor(@vendor3)
    assert_equal [@item1], market.overstocked_items
  end

  def test_it_can_return_sorted_item_list
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)
    assert_equal ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"], market.sorted_item_list
  end

  def test_it_can_return_date
    market = Market.new("South Pearl Street Farmers Market")
    market.stubs(:date).returns("24/02/2020")
    assert_equal "24/02/2020", market.date
  end

  def test_sell_method_returns_false_if_not_enough_stock
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    assert_equal false, market.sell(@item2, 10)
  end

  def test_it_returns_false_if_item_does_not_exist
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    item5 = Item.new({name: 'Onion', price: '$0.25'})
    assert_equal false, market.sell(item5, 10)
  end

  def test_sell_sells_from_vendors_in_order_they_were_added
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    market.add_vendor(@vendor3)
    market.sell(@item1, 10)
    assert_equal 25, @vendor1.check_stock(@item1)
    assert_equal 65, @vendor3.check_stock(@item1)
  end

  def test_it_can_sell_from_multiple_vendors_if_stock_is_depleted
    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(@vendor1)
    market.add_vendor(@vendor3)
    market.sell(@item1, 45)
    assert_equal 0, @vendor1.check_stock(@item1)
    assert_equal 55, @vendor3.check_stock(@item1)
  end
end

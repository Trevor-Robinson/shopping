require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/vendor'

class VendorTest < Minitest::Test
  def test_it_exists_and_has_attributes
    vendor = Vendor.new("Rocky Mountain Fresh")
    assert_instance_of Vendor, vendor
    assert_equal "Rocky Mountain Fresh", vendor.name
    assert_equal ({}), vendor.inventory
  end

  def test_check_stock_returns_0_if_item_not_stocked
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    assert_equal 0, vendor.check_stock(item1)
  end

  def test_it_can_stock_items
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    vendor.stock(item1, 30)
    assert_equal ({item1 => 30}), vendor.inventory
    assert_equal 30, vendor.inventory[item1]
  end

  def test_check_stock_can_return_stock
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    vendor.stock(item1, 30)
    assert_equal 30, vendor.check_stock(item1)
  end

  def test_stocking_existing_item_adds_to_item_stock
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    vendor.stock(item1, 30)
    vendor.stock(item1, 12)
    assert_equal 42, vendor.check_stock(item1)
  end

  def test_it_can_stock_multiple_items
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    item2 = Item.new({name: 'Tomato', price: '$0.50'})
    vendor.stock(item1, 30)
    vendor.stock(item2, 10)
    assert_equal ({item1 => 30, item2 => 10}), vendor.inventory
  end

  def test_it_can_calculate_potential_revenue
    vendor = Vendor.new("Rocky Mountain Fresh")
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    item2 = Item.new({name: 'Tomato', price: '$0.50'})
    vendor.stock(item1, 30)
    vendor.stock(item2, 10)
    assert_equal 27.50, vendor.potential_revenue
  end
end

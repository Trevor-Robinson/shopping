require 'pry'

class Market
  attr_reader :name,
              :vendors
  def initialize(name)
    @name = name
    @vendors = []
    @date = (Date.today).to_s
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    vendors.find_all do |vendor|
      vendor.check_stock(item) > 0
    end
  end

  def total_inventory
    inventory = {}
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        inventory[item] ||= {quantity: 0, vendors: []}
        inventory[item][:quantity] += quantity
        inventory[item][:vendors] << vendor
      end
    end
    inventory
  end

  def overstocked_items
    overstocked = []
    total_inventory.each do |item, hash|
      overstocked << item if hash[:quantity] > 50 && hash[:vendors].length > 1
    end
    overstocked
  end

  def sorted_item_list
    names = []
    total_inventory.each do |item, hash|
       names << item.name
    end
    names.sort
  end

  def sell(item, quantity)
    return false if !total_inventory.key?(item)
    return false if total_inventory[item][:quantity] < quantity
    total_inventory[item][:vendors].each do |vendor|
      if vendor.inventory[item] > quantity
        vendor.inventory[item] -= quantity
        quantity -= quantity
      elsif vendor.inventory[item] < quantity
        quantity -= vendor.inventory[item]
        vendor.inventory[item] = 0
      end
    end
  end
end

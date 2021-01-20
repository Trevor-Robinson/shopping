class Vendor
  attr_reader :name,
              :inventory
  def initialize(name)
    @name = name
    @inventory = {}
  end

  def check_stock(item)
    return 0 if !inventory.key?(item)
    @inventory[item]
  end

  def stock(item, stock)
    if inventory.key?(item)
      inventory[item] = (inventory[item] + stock)
    elsif !inventory.key?(item)
      inventory[item] = stock
    end
  end

  def potential_revenue
    @inventory.sum do |item, stock|
      item.price * stock
    end.round(2)
  end
end

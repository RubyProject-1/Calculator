class ShoppingItem

  def initialize(name, price, quantity)
    @name = name
    @price = price
    @quantity = quantity
    @tPrice = price * quantity
  end

  attr_accessor :name
  attr_accessor :price
  attr_accessor :quantity
  #attr_accessor :tPrice


  def updatePrice # updates price for changed quantity/price
    @tPrice = price * quantity
  end

  def tPrice  # returns total price
    updatePrice()
    @tPrice
  end
    
end



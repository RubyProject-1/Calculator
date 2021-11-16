require_relative 'shoppingItem'
listOfItems = []
$discount = false
$discountAmt = 0
def calculate (state, arr, sale = 0, total = 0)
    print "Shopping List\n-------------\n"
    for i in arr  # sums totals
      total = total + i.tPrice
    end
    
    subtotal = priceCalculate(total,sale).round(2) #calculates subtotal
    salesTax = taxCalulate(subtotal,state) #calculates sales tax amount
    printItems(arr)  #prints names of items in array

    if $discount == true  #prints if there is discount
      print "---DISCOUNT!---\n"
      print "You saved $", $discountAmt, "!\n"
    end

    print "-------------\nSubtotal: $", subtotal
    total = totalCalculate(subtotal,salesTax).round(2) #calulates total price of item
    puts
    print "Total: $", total, "\n\n"
end #end function

def priceCalculate(price,sale)
    $discountAmt = discountCalculate(price,sale)
    price = price - $discountAmt
    
    if sale > 0
      $discount = true
    end

    return price
end

def discountCalculate(price, sale)
    sale = sale / 100.to_f 
    discount = price * sale
    return discount
end

def totalCalculate(subTotal, salestax)
    total = subTotal + salestax
    return total
end

def taxCalulate(price,state)
    case state
    when "Alabama"
        return price * 0.04
    when "Alaska"
        return price * 0
    when "Arizona"
        return price * 0.056
    when "Arkansas"
        return price * 0.065
    when "California"
        return price * 0.0725
    #...
    else
        puts "Error, Please enter a correct state"
    end #end if
end

def printItems(arr)
  for i in arr
    puts "$" + i.name.ljust(10) + i.tPrice.to_s
  end
end
#main code
item1 = ShoppingItem.new("Eggs", 4.20, 2)
item2 = ShoppingItem.new("Chicken", 5.10, 4)
item3 = ShoppingItem.new("Milk", 3.45, 2)

listOfItems.append(item1)
listOfItems.append(item2)
listOfItems.append(item3)

calculate("California", listOfItems)
calculate("Alaska", listOfItems, 10)

  
    
    

#calculate("California", 100.00,10)
#puts
#puts
#calculate("California", 100.00)


# puts 20/100.to_f

# if (sale > 0)
#         sale = sale / 100.to_f
#         discount = price * sale
#         price = price - discount
#         subtotal = price
#         total = price + salesTax
#         puts subtotal
#         puts total
#     else
#         price = price - discount
#         subtotal = price
#         total = price + salesTax
#     end #end of if statement



def calculate (state, price, sale = 0)
    subtotal = priceCalculate(price,sale).round(2) #calculates subtotal
    salesTax = taxCalulate(subtotal,state) #calculates sales tax amount
    print "subtotal: ", subtotal
    total = totalCalculate(subtotal,salesTax).round(2) #calulates total price of item
    puts
    print "total: ", total
end #end function

def priceCalculate(price,sale)
    discountAmt = discountCalculate(price,sale)
    price = price - discountAmt
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

    
    
    

calculate("California", 100.00,10)
puts
puts
calculate("California", 100.00)


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
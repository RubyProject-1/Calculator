class PriceError < StandardError
    def message
        "Enter a price that is zero or greater"
    end
end

class SaleError < StandardError
    def message
        "Enter a sale that is zero or greater"
    end
end

def calculate (state, price, sale = 0)
    raise PriceError if price < 0 
    raise SaleError if sale < 0 
    subtotal = priceCalculate(price,sale).round(2) #calculates subtotal
    salesTax = taxCalulate(subtotal,state) #calculates sales tax amount
    print "subtotal: $", '%.2f' % subtotal #'%.2f' helps us round to two decimals & displays 0's
    total = totalCalculate(subtotal,salesTax).round(2) #calulates total price of item
    puts
    print "total: $", '%.2f' % total
    if(sale > 0)
        puts
        print "saved: $" '%.2f' % discountCalculate(price, sale)
    end
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

#state taxes, global var
$stateTax = {"Alabama" => 0.04,"Alaska" => 0,"Arizona" => 0.056,"Arkansas" => 0.065,"California" => 0.0725,"Colorado" => 2.900/100,"Connecticut" => 6.350/100,
             "Delaware" => 0,"Florida" => 6.000/100,"Georgia" => 4.000/100,"Hawaii" => 4.000/100,"Idaho" => 6.000/100,"Illinois" => 6.250/100,"Indiana" => 7.000/100, 
             "Iowa" => 6.000/100,"Kansas" => 6.500/100,"Kentucky" => 6.000/100,"Louisiana" => 4.450/100,"Maine" => 5.500/100,"Maryland" => 6.000/100,"Massachusetts" => 6.250/100,  
             "Michigan" => 6.000/100,"Minnesota" => 6.875/100,"Mississippi" => 7.000/100,"Missouri" => 4.225/100,"Montana" => 0,"Nebraska" => 5.50/100,"Nevada" => 6.85/100, 
             "New Hampshire" => 0,"New Jersey" => 6.625/100,"New Mexico" => 5.125/100,"New York" => 4.000/100,"North Carolina" => 4.750/100,"North Dakota" => 5.000/100,"Ohio" => 5.750/100,
             "Oklahoma" => 4.500/100,"Oregon" => 0,"Pennsylvania" => 6.000/100,"Rhode Island" => 7.000/100,"South Carolina" => 6.000/100,"South Dakota" => 4.500/100,"Tennessee" => 7.000/100,
             "Texas" => 6.250/100,"Utah" => 4.850/100,"Vermont" => 6.000/100,"Virginia" => 4.300/100,"Washington" => 6.500/100,"West Virginia" => 6.000/100,"Wisconsin" => 5.000/100,"Wyoming" => 4.000/100
            }

def taxCalulate(price,state_key)
    return ("#{price * $stateTax[state_key]}").to_f
end

calculate("California", -1.00,-1)


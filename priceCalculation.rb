class NegativeError < StandardError
    def message
        "Negative Price or Negative Sale Error" # error message that displays to console if not rescued
    end
end

class StateAbbreviationError < StandardError   
    def message
        "Not a valid state abbreviation"
    end
end

def calculate (state = "CA", price = 0, sale = 0) #calculates and returns subtotal, total, and saved values

    raise StateAbbreviationError.new if ! $stateAbbreviations.key?(state)

    state = $stateAbbreviations[state]

    raise NegativeError.new if (price < 0 || sale < 0)

    subtotal = priceCalculate(price,sale).round(2) #calculates subtotal
    salesTax = taxCalulate(subtotal,state) #calculates sales tax amount
    print "subtotal: $", '%.2f' % subtotal #'%.2f' helps us round to two decimals & displays 0's
    total = totalCalculate(subtotal,salesTax).round(2) #calulates total price of item
    puts
    print "total: $", '%.2f' % total
    if(sale > 0)
        puts
        saved = discountCalculate(price, sale)
        print "saved: $" '%.2f' % saved
        puts
    end #end of if statement
    return subtotal, total, saved

end #end function

def priceCalculate(price,sale)  # calculates price
    discountAmt = discountCalculate(price,sale)
    price = price - discountAmt
    return price
end

def discountCalculate(price, sale)  # calculates discount
    sale = sale / 100.to_f 
    discount = price * sale
    return discount
end


def totalCalculate(subTotal, salestax)  # calculates total
    total = subTotal + salestax
    return total
end

$stateAbbreviations = {"AL" => "Alabama", "AK" => "Alaska", "AZ" => "Arizona", "AR" => "Arkansas", "CA" => "California", "CO" => "Colorado", "CT" => "Connecticut", "DE" => "Delaware", "FL" => "Florida", "GA" => "Georgia", "HI" => "Hawaii", 
    "ID" => "Idaho", "IL" => "Illinois", "IN" => "Indiana", "IA" => "Iowa", "KS" => "Kansas", "KY" => "Kentucky", "LA" => "Louisiana", "ME" => "Maine", "MD" => "Maryland", "MA" => "Massachusetts", "MI" => "Michigan", "MN" => "Minnesota", 
    "MS" => "Mississippi", "MO" => "Missouri", "MT" => "Montana", "NE" => "Nebraska", "NV" => "Nevada", "NH" => "New Hampshire", "NJ" => "New Jersey", "NM" => "New Mexico", "NY" => "New York", "NC" => "North Carolina", "ND" => "North Dakota", 
    "OH" => "Ohio", "OK" => "Oklahoma", "OR" => "Oregon", "PA" => "Pennsylvania", "RI" => "Rhode Island", "SC" => "South Carolina", "SD" => "South Dakota", "TN" => "Tennessee", "TX" => "Texas", "UT" => "Utah", "VT" => "Vermont", 
    "VA" => "Virginia", "WA" => "Washington", "WV" => "West Virginia", "WI" => "Wisconsin", "WY" => "Wyoming"}

#state taxes, global var
$stateTax = {"Alabama" => 0.04,"Alaska" => 0,"Arizona" => 0.056,"Arkansas" => 0.065,"California" => 0.0725,"Colorado" => 2.900/100,"Connecticut" => 6.350/100,
             "Delaware" => 0,"Florida" => 6.000/100,"Georgia" => 4.000/100,"Hawaii" => 4.000/100,"Idaho" => 6.000/100,"Illinois" => 6.250/100,"Indiana" => 7.000/100, 
             "Iowa" => 6.000/100,"Kansas" => 6.500/100,"Kentucky" => 6.000/100,"Louisiana" => 4.450/100,"Maine" => 5.500/100,"Maryland" => 6.000/100,"Massachusetts" => 6.250/100,  
             "Michigan" => 6.000/100,"Minnesota" => 6.875/100,"Mississippi" => 7.000/100,"Missouri" => 4.225/100,"Montana" => 0,"Nebraska" => 5.50/100,"Nevada" => 6.85/100, 
             "New Hampshire" => 0,"New Jersey" => 6.625/100,"New Mexico" => 5.125/100,"New York" => 4.000/100,"North Carolina" => 4.750/100,"North Dakota" => 5.000/100,"Ohio" => 5.750/100,
             "Oklahoma" => 4.500/100,"Oregon" => 0,"Pennsylvania" => 6.000/100,"Rhode Island" => 7.000/100,"South Carolina" => 6.000/100,"South Dakota" => 4.500/100,"Tennessee" => 7.000/100,
             "Texas" => 6.250/100,"Utah" => 4.850/100,"Vermont" => 6.000/100,"Virginia" => 4.300/100,"Washington" => 6.500/100,"West Virginia" => 6.000/100,"Wisconsin" => 5.000/100,"Wyoming" => 4.000/100
            }

def taxCalulate(price,state_key)  # returns tax based on state
    return ("#{price * $stateTax[state_key]}").to_f
end

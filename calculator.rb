# @author Rosalinda Chamale,
def menu
    puts "\nChoose an option by inputting a number between 1 and 6"
    puts "1. Add the numbers"
    puts "2. Subtract the numbers"
    puts "3. Multiply the numbers"
    puts "4. Divide the numbers"
    puts "5. Exponent operation"
    puts "6. Exit"
    print("Enter your choice: ")
    @choice = gets.to_i #choice is instance variable, can be used outside of function
    puts("\n")
end

def recalculate
    puts "\nDo you want to do another operation on the same numbers? (enter 7)"
    puts "Do you want to do another operation on different numbers? (enter 8)"
    puts "Exit (enter 9)"
    option = gets.to_i
    if option == 7
        menu()
    elsif option == 8
        user_interface()
    elsif option == 9
        exit
    else #input validation
        puts "Invalid choice, try again"
        recalculate()
    end
end

def user_interface
    puts "Enter first number"
    num1 = gets.to_i #converts any input to integer, if not a number it will become 0
    puts "Enter second number"
    num2 = gets.to_i
    menu()
    while @choice != 6 # will prompt user with menu until 6 is entered (exit option)
        case @choice 
        when 1
            puts "You chose addition"
            sum = num1 + num2
            puts "The sum of the 2 numbers is #{sum}"
            recalculate()
        when 2
            puts "You chose subtraction"
            difference = num1 - num2
            if num2 > num1
                difference = num2 - num1
            end
            puts "The difference is #{difference}"
            recalculate()
        when 3
            puts "You chose multiplication"
            product = num1 * num2
            puts "The product of the 2 numbers is #{product}"
            recalculate()
        when 4
            puts "You chose division"
            division = num1/num2 # using integer division
            if num2 > num1
                division = num2/num1
            end
            puts "The answer is #{division}"
            recalculate()
        when 5
            puts "You chose exponent operation"
            exponent_op = num1 ** num2 # equivalent to num1 ^ num2
            puts "The answer is #{exponent_op}"
            recalculate()
        when 6
            exit
        else 
            puts "Error: invalid choice, try again."
            menu()
        end
    end
end

user_interface()


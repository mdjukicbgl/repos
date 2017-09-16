import sys

'''
CTRL-S to save the file
CTRL-B to build the file, ie to run it

'''

def main(args):

	print("Start of script")

	# define 2 varables
	a = 8
	b = 2

	# display th result of adding the variable values
	print 'Addition\t', a, "+", b, "=", a + b
	
	# display the result of subtraction th variable values
	print 'Subtraction\t', a, '-', b, '=', a - b

	# display the result of multiplying the varable names 
	print 'Multiplication\t', a, '*', b, '=', a * b

	# display the result of dividing the variable values
	print 'Division\t', a, '/', b, '=', a / b

	# display the result of dividing the variabl evalues both with and without the floating-point value
	print 'Floor Division\t', a, '/', b, '=', a // b

	# display the result of the remainder after dividing the values
	print 'Modulus\t', a, '%', b, '=', a % b

	# display the result of raising the first operand to the power of the second
	print 'Exponent\t', a, '**', b, '=', a ** b
	print 'Exponent\t', a, '**', b, '=', a ** b, sep=' '
	# NOTE: you can use the sep parameter to explicitly specify the separation between output

	print("End of script")


#
# call the main function with arguments passed
#
if __name__ == "__main__" :
  	    main(sys.argv[1:])

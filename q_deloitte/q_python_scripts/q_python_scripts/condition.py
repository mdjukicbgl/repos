
import sys

'''
(test-expression) ? if true return this : if false return this
if true return this if (test expression) else if false return this
if true do this if( var != 1) else if alse do this

The conditional expression can be used in Python programming to assign th emaximum or minimum value of two variables to a
third variable.  For example, to assign a minimum like this:
eg. c = a if (a < b ) else b

Another common use of th econditional expression incorporates the % (modulus) operator in the test expression to determine if the
value of a variable is either an odd number or an even number
if true (odd) to this if ( var % 2 != 0) else if false (even) do this

'''


def main(args):

	a = 1
	b = 2

	# add statements to display the results fo conditional evaluation - describing the firs variable's value
	print '\n'
	print 'variable a is :', a, 'ONE' if ( a == 1 ) else 'NOT ONE'
	print 'variable a is :', a, 'EVEN' if ( a % 2  == 0 ) else 'ODD'

	# add statements to display the results for the second variable
	print 'variable b is :', b, 'One' if ( b == 1 ) else 'NOT ONE'
	print 'variable b is :', b, 'EVEN' if ( b % 2  == 0 ) else 'ODD'

	# add a max expression as follows
	print 'variable max is :', a if a > b else b


if __name__ == "__main__":
		main(sys.argv[1:])

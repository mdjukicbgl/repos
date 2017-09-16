
import sys

def main(args):
	#pass

	'''
	int(x) - converts x to an integer whole number
	float(x) - converts x to a floating point number
	str(x) - converts x to a string representation
	chr(x) - converts integer x to a character
	unichr(x) - converts integer to a Unicode character
	ord(x) - converts character x to its integer value
	hex(x) - converts integer x to a hexidecimal string
	oct(x) - converts integer x to an octal string

	for t in range(25):
 		print t
	''' 

	# initialize two variables with numericvalues from user input:
	a = raw_input('Enter a number: ')
	b = raw_input('Enter a another number: ')

	# add state ment to add th evariable values together then dispaly the combined result and its data type - to see
	# a concatenated string value result
	sum = a + b
	print '\n'
	print 'Data type sum: ', sum, type(sum)

	# add statements to add cast variable values together, then display the result and its data type - to see a total integer value result
	sum = int(a) + int(b)
	print 'Data Type sum: ', sum, type(sum)

	# cast as float
	sum = float(sum)
	print 'Data Type sum: ', sum, type(sum)
		

if __name__ == '__main__':
	main(sys.argv[1:])
'''
comparison.py

'''
import sys

def main(args):

	print 'Start of script.....\n'

	nil = 0
	num = 0
	max = 1
	cap = 'A'
	low = 'a'

	# Add statements to display the results of numeric and character equality comparisons
	print 'Equality:\t', nil, '==', num, nil == num
	print 'Equality:\t', cap, '==', low, cap == low

	# NOTE: the equality operator above, compares two operands and will return TRUE, if both are equal in value,
	#       otherwise, it will return a False value. 

	# Add statements to display the results of numeric and character equality comparisons
	print 'inequality:\t', nil, '!=', max, nil != max

	# Add statements to display the results of numeric and character equality comparisons
	print 'Greater:\t', nil, '>', max, nil > max
	print 'Lesser:\t', nil, '<', max, nil < max

	# Finally, add statements to display the results of greater or equal and lower or equal comparisons
	print 'More or Equal:\t', nil, '>=', num, nil >= num
	print 'Less or Equal:\t', max, '<=', num, max <= num

	print 'End of script.....\n'

if __name__ == "__main__":
   main(sys.argv[1:])


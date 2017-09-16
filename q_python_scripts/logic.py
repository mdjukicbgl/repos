
import sys

def main(args):

	print 'Start of mainline.....\n'

	''' 
	and - logical and
	or - logical or
	not - logical not

	'''
	a = True
	b = False

	# add statements to display the results of logical AND evaluations
	print 'AND Logic.....'
	print 'a and a = ', a and a
	print 'a and b = ', a and b
	print 'b and b = ', b and b

	# now add statements to display the results of logical OR evaluations
	print '\nOR Logic.....'
	print 'a or a = ', a or a
	print 'a or b = ', a or b
	print 'b or b = ', b or b

	# Finally, add statements to display the results of logical NOT evaluations
	print '\nNOT Logic...'
	print 'a =', a, '\tnot a = ', not a
	print 'b =', b, '\tnot b = ', not b



	print '\nEnd of mainline.....'


if __name__ == "__main__":
	main(sys.argv[1:])


import sys

def main(args):
	#pass
	print 'Start of list.py.....'

	# initialize the list
	quarter = ["January", "February", "March"]


	print 'First Month: ', quarter[0]
	print 'Second Month: ', quarter[1]
	print 'Third  Month: ', quarter[2]

	# add a statement to create a multi-dimensional list of two elements, which themselves are lists that each have
	# three elements containing integer values:
	coords = [[1,2,3], [4,5,6]]

	# add statements to display the values contained in two specific inner list elements
	print '\n'
	print 'coords:', coords
	print 'Top Left 0,0:', coords[0][0]
	print 'Top Left 0,1:', coords[0][1]
	print 'Bottom Right 1,2:', coords[1][2]

	# finally, add a statement to display just one character of a string value
	print 'Second Month First Letter', quarter[1][0]
	print 'Second Month Fifth Letter', quarter[1][4]
	print 'Third Month Fifth Letter', quarter[2][4]

	try:
		print 'Third Month non-existanct sixth  Letter', quarter[2][5]
	except Exception , e:
	  	#raise e
		#print 'IndexError: mdj - string index out of range'
		print e
		print '\n'
		print 'End of list.py.....'

if __name__ == '__main__':
	main(sys.argv[1:])


import sys

def main(args):
	print '\n'
	print 'Start of pop.py....'

	'''
	Manipulating lists

	list method			Description
	--------------------------------------------------------------
	list.append(x)		Adds  item x to the end of the list
	list.extend(l)		Adds all items in list l to the end of the list
	list.insert(i,x)	Inserts item x at indes position i
	list.remove(x)		Removes first item x from the list
	list.pop(i)			Removes item at index position i and returns it
	list.index(x)		Returns the index position in the list of first item x
	list.count(x)		Returns the nddumber of times x appears i the list
	list.sort()			Sort all list items, in place
	list.reverse()		Revers all list items, in place
	
	'''

	# initialize two lists of three elements each containing string values
	basket = ['Apple', 'Bun', 'Cola']
	crate = ['Egg', 'Fig', 'Grape']

	# add statements to display the contents of the first list's elements and its length
	print 'Basket List:', basket
	print 'Basket Elements:', len(basket) 
	print 'Crate List:', crate
	print 'Crate Elements:', len(crate) 
	print '\n'

	# add statements to add an element and display all list elements, 
	# then remove the final element and display all list elements once more
	basket.append('Damson')
	print 'Appended:', basket
	print 'Last Item Removed:', basket.pop()
	print 'Basket List:', basket
	print '\n'

	# Finally, add statements to add all elements of the second list to the first list, and display
	# all the first list elements, then remove elements and display the first list again
	basket.extend(crate)
	print 'Extended:', basket
	del basket[1]
	print 'Item Removed:', basket
	del basket[1:3]
	print 'Slice Removed:', basket

	print '\n'
	print 'End of pop.py....'
	
if __name__ == '__main__':
		main(sys.argv[1:])	
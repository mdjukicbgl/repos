
'''
Employing variables.....Page 18-19
'''

import sys

def main(args):

	print('Start of var.py.....\n')

	# initialize a variable with an integre value
	print('initialize a variable with an integre value')
	var = 8
	print(var)

	# Assign a float value to the variable
	print('Assign a float value to the variable')
	var = 3.142
	print(var)

	# Assign a string value to the variable
	print('Assign a string value to the variable')
	var = 'Python in easy steps'
	print(var)

	# Assign a Boolean value
	print('Assign a Boolean value')
	var = True
	print(var)

	print('\nEnd of var.py.....')

if __name__ == "__main__":
    main(sys.argv[1:])


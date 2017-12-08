
'''
Obtaining user input.....Page 20-21
the line below was initially 6 lines, and then selecting all lines, then Ctrl+Shift+L, Del at end of first line will 
automatically join all of the lines together

days = ["1","2","3","4","5","6"]

'''
import sys

def main(args):

	try:
		print('Start of input.py.....\n')
		user = raw_input("I am Python.  What is your name? :")
 	
	 	# output a string and a variable value
 		print('Welcome', user)

		print('\nEnd of input.py.....')

	except 	EOFError:
		print('\nEOFError encountered')

try:
    text = input('Enter something: ')
    print text
except EOFError:
    print('\nEOFError')


# output a string and a variable value
if __name__ == "__main__":
  	    main(sys.argv[1:])

#!/usr/bin/env python

from __future__ import print_function
import sys

def modulus():
    """
    - Modulus() use modulus to print agreed conditions
        - divisible by 3 and divisible by 5
    """
    for i in range(1,15+1):
        #print("n-->%s" %(i))

        if i % 3 == 0 and i % 5 == 0 :
            print('FizzBuzz')
        elif i % 3 == 0 :
                print('Fizz')
        elif i % 5 == 0 :
            print('Buzz')
        else:
            print(i)



def main(args):
    """
    - Calling main function
    """
    help(modulus)
    modulus()


if __name__ == '__main__' :

    help(main)
    main(sys.argv[1:])
     



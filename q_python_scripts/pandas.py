import pandas as pd
import os
import sys

print "Hi! This is a cell. Press the button above to run it"

def main(args):
	print_10_nums()
	%time sum([x for x in range(100000)])

def print_10_nums():
    for i in range(10):
        print i,

if __name__ == '__main__':
	main(sys.argv[1:])

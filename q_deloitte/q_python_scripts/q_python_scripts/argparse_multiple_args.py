#!/usr/bin/env python

from __future__ import print_function

import argparse, os, sys


if __name__ == '__main__':
	parser = argparse.ArgumentParser()

	parser.add_argument(
		"-b",
		"--batchid",
		help="The Batch Id of the process being passed",
		default=1,
		type=int)

	parser.add_argument(
		'-t',
		nargs = '*',
		dest='transforms',
		default = argparse.SUPPRESS,
		help = 'The name of the transform to load')

	args = parser.parse_args()


	for key, value in vars(args).iteritems():
		#print('key/value-->', key, value)
	
		if key == 'transforms':
			rec = []		
			rec = value
			print('value-->', value)

			for transform in value:
				print('transform-->', transform)
	

#
# when run, as follows from the command line, 
# argparse_multiple_args.py -i a b c
#
# it will return the following output
# args-->Namespace(ids=['a', 'b', 'c'])
#


#
# Start of mainline.....
#
'''
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    
    parser.add_argument(
        "-b",
        "--batchid",
        help="The Batch Id of the process being passed",
        default=1,
        type=int)
    
    parser.add_argument(
        "-t",
        "--transform",
        help="The name of the transform to load",
        default='/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/sampleSQLfile2.dat',
        type=str)
    
    args = parser.parse_args()

    
    #
    # pass in batchid
    #
    if not (vars(args))['batchid']:
        parser.print_help()
        sys.exit(1)

    #
    # pass in transform to execute
    #
    if not (vars(args))['transform']:
        parser.print_help()
        sys.exit(1)    
    
    BATCH_ID = str(args.batchid)
    FILENAME = str(args.transform)
    
    main(sys.argv[1:])

#
# That's all Folks!!!!
#
'''
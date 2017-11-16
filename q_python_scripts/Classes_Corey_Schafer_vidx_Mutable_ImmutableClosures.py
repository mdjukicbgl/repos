#!/usr/bin/env python

# mutable and immutable

from __future__ import print_function

# a, a object is immutable
a = 'corey'
print(a)
print("Address of a is: {}".format(id(a)))

# however, we can redefine it once again here
# which begs the question, is it really immutable???
# well, the id function, will provide the address of the variable
# and we can see from the first definition above, that the 2nd
# definition, is merely a copy.  Hence the 2 different addresses
#
a = 'marko'
print(a)
print("Address of a is: {}".format(id(a)))

# output of 
#corey
#Address of a is: 54310112
#marko
#Address of a is: 54312632

#
# try changing the first char of a to UPPERCASE
#

#print("Address of a is: {}".format(id(a)))
#a[0] = 'C'
#print(a)
# ERROR MSG, TypeError: 'str' object does not support item assignment
#
##################################################################
# so, what object is MUTABLE?? Ans, a list.
##################################################################
#
#a = [1,2,3,4,5]
#print(a)
#print("Address of a is: {}".format(id(a)))
#
#a[0] = 99
#print(a)
#print("Address of a is: {}".format(id(a)))
#
##################################################################
# another example.....
##################################################################
#
employees = ['Corey', 'John', 'Rick', 'Steve', 'Carl', 'Adam']
output = '<ul>\n'

for i in employees:
    output += "\t<li>{}</li>\n".format(i)
    print("Address of output is: {}".format(id(output)))

output += "</ul>"

print(output)

print("\n")

# output below - note all memory locations for list
# this can impact performance with the usage of so much memory
#
#corey
#Address of a is: 57869936
#marko
#Address of a is: 57871256
#Address of output is: 57832648
#Address of output is: 57063728
#Address of output is: 57170736
#Address of output is: 53728632
#Address of output is: 56990936
#Address of output is: 57135152
#<ul>
#	<li>Corey</li>
#	<li>John</li>
#	<li>Rick</li>
#	<li>Steve</li>
#	<li>Carl</li>
#	<li>Adam</li>
#</ul>
#

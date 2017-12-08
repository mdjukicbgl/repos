
#from __future__ import print_function
#import argparse
#
#print("argparse-->", dir(argparse))
#parser = argparse.ArgumentParser()
#parser.parse_args()
#
# Here is what is happening
# Running the script without any options result in nothing displayed to stdout - Not so useful
# The second one start to display the usefulness of the argparse module.  We have done almost nothing,
# but we geta nice help message
# The --help option, which can also be shortened to '-h', is the only option we get free(ie. no need to specify it)
# Specifying anything else, results in an error.  But even then, we do get a useful usage message, 
# also for free.

# Introducing positional parameters
#from __future__ import print_function
#import argparse
#
#parser = argparse.ArgumentParser()
#parser.add_argument("echo")
#args = parser.parse_args()
#print("listing echo-->:", args.echo)

# We've added the add_argument() method, which is what we use to specify which command-line options
# the program is willing to accept.
# In this case, I've named it 'echo', so that it's in line with its function.
# Calling our program now requires us to specify an option.
# The parse_args() method, actually retuns some data fro teh options specified, in this case 'echo'

from __future__ import print_function
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("echo", help="echo the string you use here")
args = parser.parse_args()
print args.echo


parser = argparse.ArgumentParser()
parser.add_argument("square", help="display a square of a given number")
args = parser.parse_args()
print args.echo

parser = argparse.ArgumentParser()
parser.add_argument("square", help="display a square of a given number")
args = parser.parse_args()
print(args.square**2)

# Introducing Optional arguments
# so far, we have been paying with positional parameters.  
# Let us have a look on how to add optional ones:
#
from __future__ import print_function
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--verbosity", help="increase output verbosity")
args = parser.parse_args()
if args.verbosity:
	print("verbosity is turned on")
else:
	print("verbosity is turned off")


# processing argparse
from __future__ import print_function
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-a', action="store_true", default=False)
parser.add_argument('-b', action="store", dest="b")
parser.add_argument('-c', action="store", dest="c", type=int)
args = parser.parse_args()
print(args)

#
# The default action is to store the argument value. 
# In this case, if a type is provided, the value is converted to that type before it is stored. 
# 
# dest - If the dest argument is provided, the value is saved to an attribute of that name 
# on the Namespace object returned when the command line arguments are parsed.

# ARGUMENT ACTIONS
# There are 6 built-in actions that can be triggered when an argument is encountered:
#
# store - Save the value, after optionally converting it to a different type. This is the default action 
# taken if none is specified explicitly.
#
# store_const - Save a value defined as part of the argument specification, rather than a value
# that comes from the arguments being parsed.  This is typically used to implement command line flags that
# aren't booleans.
#
# store_true/store_false - Save the appropriate boolean value.
# These actions are used to implement boolean switches.
#
# append - Save the value to a list.  Multiple values are saved if the arguement is repeated.
#
# append_const - Save a value defined in the argument specification to a list.
#
# version - Prints version details about the program and then exists.
#
from __future__ import print_function
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-s', action='store', dest='simple_value', help='Store a simple value')
parser.add_argument('-c', action='store_const',  dest='constant_value', const='value-to-store', help='Store a constant value')
parser.add_argument('-t', action='store_true',   dest='boolean_switch',  default=False, help='Set a switch to true')
parser.add_argument('-f', action='store_false',  dest='boolean_switch', default=False,  help='Set a switch to false')
parser.add_argument('-a', action='append',       dest='collection',     default=[], help='Add repeated values to list')
parser.add_argument('-A', action='append_const', dest='const_collection', const='value-1-to-append', default=[],
					help='Add different values to list')
parser.add_argument('-B', action='append_const', dest='const_collection', const='value-2-to-append',
					help='Add different values to list')
parser.add_argument('--version', action='version', version='%(prog)s 1.0')

args=parser.parse_args()

print('simple_value		=', args.simple_value)
print('constant_value   =', args.constant_value)
print('boolean_switch   =', args.boolean_switch)
print('collection       =', args.collection)
print('const_collection =', args.const_collection) 


# cloudbi implementation:

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-p",
        "--profile",
        help="The name of the profile in the .aws folder with access to the KMS key",
        type=str)
    parser.add_argument(
        "-f",
        "--filetype",
        help="The name of the filetype to process",
        type=str)
    parser_args = parser.parse_args(args)
    if not (vars(parser_args))['profile']:
        parser.print_help()
        sys.exit(1)
    aws_profile = str(parser_args.profile)


#Daily Python Tip
#
# OPTION PREFIXES
# The default syntax for options is based on the UNIX convention of 
# signifying command line switches using a prefix of '-', argparse
# supports other prefixes, so you can make your program conform to
# the local platform default ie. use '/' on Windows, or follow a
# different convention.

from __future__ import print_function
import argparse

parser = argparse.ArgumentParser(description='Change the option prefix characters', prefix_chars='-+/')
parser.add_argument('-a', action='store_false', default=None, help='Turn A off')
parser.add_argument('+a', action='store_true', default=None, help='Turn A on')
parser.add_argument('//noarg', '++noarg', action='store_true', default=False)
args = parser.parse_args()
print('arguments-->', args)

# SOURCE OR ARGUMENTS
# In the examples so far, the list or arguments given to the parser have come from a list passed
# explicitly, or were taken implicitly from sys.argv.
# Passing the list explicitly is useful when you are using argparse to process command line-like
# instructions that do not come from the command line(such as a config file)

from __future__ import print_function
import argparse
from ConfigParser import ConfigParser
import shlex

parser = argparse.ArgumentParser(description='Short sample app')
parser.add_argument('-a', action='store_true', default=False)
parser.add_argument('-b', action='store', dest='b')
parser.add_argument('-c', action='store', dest='c', type=int)

config = ConfigParser()
config.read('argparse_witH_shlex.ini')
config_value = config.get('cli', 'options')
print('Config  :', config_value)

argument_list = shlex.split(config_value)
print('Arg List:', argument_list)

print('Results :', parser.parse_args(argument_list) )

##### multisection.ini
######################
#[bug_tracker]
#url = http://localhost:8080/bugs/
#username = dhellmann
#password = SECRET
#
#[wiki]
#url = http://localhost:8080/wiki/
#username = dhellmann
#password = SECRET


# simple.ini file
#################
#[bug_tracker]
#url = http://localhost:8080/bugs/
#username = dhellmann
#password = SECRET

# READING CONFIGURATION FILES
# The most common use for a configuration file is to have a user or system administrator edit the file
# with a regular text editor to set application behaviour defaults, and then have the application read the file, 
# parse it, and act, based upon its contents.
# Use read() method of SafeConfigParser to read the configuration file.

from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
#parser.read('C:\Users\mdjuk\q_python_scripts\simple.ini')
parser.read('/home/ec2-user/simple.ini')

print(parser.get('bug_tracker', 'url'))
print(parser.get('bug_tracker', 'username'))
print(parser.get('bug_tracker', 'password'))

# use SafeConfigParser to read BOTH config sections
###################################################
#[bug_tracker]
#url = http://localhost:8080/bugs/
#username = dhellmann
#password = SECRET

#[bug_tracker2]
#url = http://localhost:8080/bugs2/
#username = dhellmann2
#password = SECRET2

from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('/home/ec2-user/simple.ini')

print(parser.get('bug_tracker2', 'url'))
print(parser.get('bug_tracker2', 'username'))
print(parser.get('bug_tracker2', 'password'))
##############

from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('/home/ec2-user/simple.ini')

parser = SafeConfigParser()
parser.read(filename)

print(parser.get('bug_tracker', 'url'))
print(parser.get('bug_tracker', 'username'))
print(parser.get('bug_tracker', 'password'))

url = parser.get('bug_tracker', 'url')
username = parser.get('bug_tracker', 'username')
password = parser.get('bug_tracker', 'password')

print('url--> %s %s %s' %(url, username, password))

# The read() method also accepts a list of filenames. 
# Each name in turn is scanned, and if the file exists, it is opened and read.
from __future__ import print_function
from ConfigParser import SafeConfigParser
import glob

parser = SafeConfigParser()
candidates = ['does_not_exist.ini', 'also_does_not_exist.ini', 'simple.ini', 'multisection.ini']
found = parser.read(candidates)
missing = set(candidates) - set(found)
print('Found config files: ', sorted(found))
print('missing Files: ', sorted(missing))

# UNICODE CONFIGURATION DATA
# Configuration files containing Unicode data should be opened using the 'codecs' module to 
# set the proper encoding value.
# Changing the password value of the original input to contain Unicode characters and saving
# the results in UTF-8 encoding gives:
#
#[bug_tracker]
#url = http://localhost:8080/bugs/
#username = dhellmann
#password = ßéç®é†
#
# The codecs file handle can be passed to readfp(), which uses the readline() method of its argument
# to get lines from the file and parse them.
#
from __future__ import print_function
from ConfigParser import SafeConfigParser
import codecs

parser = SafeConfigParser()

# Open the file with the correct encoding
with codecs.open('unicode.ini', 'r', encoding='utf-8') as f: 
	parser.readfp(f)

password = parser.get('bug_tracker', 'password')

print('Password:', password.encode('utf-8'))
print('Type    :', type(password))
print('repr()   :', repr(password))

# ACCESSING CONFIGURATION SETTINGS
##################################
# SafeConfigParser includes methods for examining the structure of the parsed configuration, 
# including listing the sections and options, and getting their values.  
# The configuration file includes two sections for separate web services:
#
#[bug_tracker]
#url = http://localhost:8080/bugs/
#username = dhellmann
#password = SECRET
#
#[wiki]
#url = http://localhost:8080/wiki/
#username = dhellmann
#password = SECRET

# And this sample program exercises some of the methods for looking at the configuration data,
# including sections(), options(), and items()
from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('multisection.ini')

for section_name in parser.sections():
	print('Section:', section_name)
	print('Options:', parser.options(section_name))
	for name, value in parser.items(section_name):
		print(' %s = %s' %(name, value))
	print

# TESTING WHETHER VALUES ARE PRESENT
# To test if a section exists, use has_section(), passing the section name.
from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('multisection.ini')

for candidate in ['wiki', 'bug_tracker', 'dvcs']:
	print('%-12s: %s' %(candidate, parser.has_section(candidate)))

# Use has_option() to test if an option exists within a sector
from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('multisection.ini')

for section in ['wiki', 'none']:
	print('%s section exists: %s' %(section, parser.has_section(section)))
	for candidate in ['username', 'password', 'url', 'description']:
		print('%s.%-12s  : %s' %(section, candidate, parser.has_option(section, candidate)))
	print

# VALUE TYPES
# All section and option names are treated as strings, but option values can be strings, integers,
# floating-point numbers, or booleans.  There are a range of possible boolean values that are 
# converted true or false.
# This example file includes one of each:
#[ints]
#positive = 1
#negative = -5
#
#[floats]
#positive = 0.2
#negative = -3.14
#
#[booleans]
#number_true = 1
#number_false = 0
#yn_true = yes
#yn_false = no
#tf_true = true
#tf_false = false
#onoff_true = on
#onoff_false = false

# SafeConfigParser does not make any attemp to understad the option type.
# The application is expected to use teh correct method to fetch the value
# as the desired type.  
# get() always returns a string.  
# Use getint() for integers, getfloat() for floating point numbers, and getboolean() for boolean types.

from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('types.ini')

print('Integers:') 
for name in parser.options('ints'):
	string_value = parser.get('ints', name)
	value = parser.getint('ints', name)
	print(' %-12s : %-7r --> %d' %(name, string_value, value))

print('\nFloats:') 
for name in parser.options('floats'):
	string_value = parser.get('floats', name)
	value = parser.getfloat('floats', name)
	print(' %-12s : %-7r --> %0.2f' %(name, string_value, value))


print('\nBooleans:') 
for name in parser.options('booleans'):
	string_value = parser.get('booleans', name)
	value = parser.getboolean('booleans', name)
	print(' %-12s : %-7r --> %s' %(name, string_value, value))

# OPTIONS AS FLAGS
# Usually the parser requires an explicit value for each option, but with the 
# SafeConfigParser parameter allow_no_value set to True, an option can appear by itself
# on a line in the input file, and be used as a flag.

from __future__ import print_function
import ConfigParser

# Require values
try:
	parser = ConfigParser.SafeConfigParser()
	parser.read('allow_no_value.ini')
except ConfigParser.ParsingError as err:
	print('Could not parse: ', err)
else:
	print ('parsing.......')	

# Allow stand-alone option names:
print('\nTrying again with allow_no_value=True')
parser = ConfigParser.SafeConfigParser(allow_no_value=True)
parser.read('allow_no_value.ini')

for flag in ['turn_feature_on', 'turn_other_feature_on']:
	print('')
	print(flag)
	exists = parser.has_option('flags', flag)
	print('  has_option:', exists)
	if exists:
		print('       get:', parser.get('flags', flag))


# REMOVE SECTIONS
from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('multisection.ini')

print('Read values:\n')
for section in parser.sections():
    print(section)
    for name, value in parser.items(section):
        print('  %s = %r' % (name, value) )

parser.remove_option('bug_tracker', 'password')
parser.remove_section('wiki')
        
print('\nModified values:\n')
for section in parser.sections():
    print(section)
    for name, value in parser.items(section):
        print('  %s = %r' % (name, value))

# SAVING CONFIGURATION FILES
# Once a SafeConfigParser is populated with desired data, it can be saved to a file by calling write() method.
# This makes it possible to provide a user interface for editing the configuration settings, without
# having to write any code to manage the file.

from __future__ import print_function
import ConfigParser
import sys

sys.stdout = open('mdj_log', 'w')


parser = ConfigParser.SafeConfigParser()

parser.add_section('bug_tracker')
parser.set('bug_tracker', 'url', 'http://www.bbc.co.uk')
parser.set('bug_tracker', 'username', 'dhellmann')
parser.set('bug_tracker', 'password', 'welcome')

parser.write(sys.stdout)

sys.stdout.close()

# WRITING OUT TO FILE USING sys.stdout
######################################
###Here's some sample code based on the book Learning Python by Mark Lutz that
###addresses your question:
###import sys
###temp = sys.stdout                 # store original stdout object for later
###sys.stdout = open('log.txt', 'w') # redirect all prints to this log file
###print("testing123")               # nothing appears at interactive prompt
###print("another line")             # again nothing appears. it's written to log file instead
###sys.stdout.close()                # ordinary file object
###sys.stdout = temp                 # restore print commands to interactive prompt
###print("back to normal")           # this shows up in the interactive prompt###

# OPTION SEARCH PATH
# SafeConfigParser uses a multi-step search process when looking for an option.
# Before starting the option search, the section name is tested.  If the section does not exist, 
# and the name is not the special value DEFAULT, when NoSectionError is raised.
# 1. If the option name appears in the vars dictionary passed to get(), the value from vars is returned.
# 2. If the option name appears in the specified section, the value from that section is returned.
# 3. If the option name appears in the DEFAULT section, that value is returned.
# 4. If the option name appears in the defaults dictionary passed to the constructor, that value is returned.

#[DEFAULT]
#file-only = value from DEFAULT section
#init-and-file = value from DEFAULT section
#from-section = value from DEFAULT section
#from-vars = value from DEFAULT section
#
#[sect]
#section-only = value from section in file
#from-section = value from section in file
#from-vars = value from section in file

from __future__ import print_function
import ConfigParser

# Define the names of the options
option_names = [
	  'from-default'
	, 'from-section'
	, 'section-only'
	, 'file-only'
	, 'init-only'
	, 'init-and-file'
	, 'from-vars'
	]

# Initialize the parser with some defaults
parser = ConfigParser.SafeConfigParser(
	defaults={ 'from-default':'value from defaults passed to init'
	         , 'init-only':'value from defaults passed to init'
	         , 'init-and-file':'value from defaults passed to init'
	         , 'from-section':'value from defaults passed to init'
	         , 'from-vars':'value from detaults passed to init'
	         }	
	         )

print('Defaults before loading file:')
defaults = parser.defaults()
for name in option_names:
	if name in defaults:
		print('  %-15s = %r' %(name, defaults[name]))

# LOAD THE CONFIGURATION FILE
parser.read('with-defaults.ini')

print('\nDefaults after loading file:')
defaults = parser.defaults()
for name in option_names:
	if name in defaults:
		print('  %-15s = %r' %(name, defaults[name]))

# DEFINE SOME LOCAL OVERRIDES
vars = {'from-vars':'value from vars'}

# SHOW THE VALUES OF ALL OF THE OPTIONS
print('\nOption lookup:')
for name in option_names:
	value = parser.get('sect', name, vars=vars)
	print('  %-15s = %r' %(name, value))

# SHOW ERROR MESSAGES FOR OPTIONS THAT DO NOT EXIST
print('\nError cases:')
try:
		print('No such option:', parser.get('sect', 'no-option'))
except ConfigParser.NoOptionError as err:
		print(str(err))

try:
    print('No such section:', parser.get('no-sect', 'no-option'))
except ConfigParser.NoSectionError as err:
    print(str(err))

# COMBINING VALUES WITH INTERPOLATION
# SafeConfigParser provides a feature called interpolation that can be used to combine values together.
# Values containing standard Python format strings trigger the interpolation feature when they are
# retrieved with get().
# Options named within the value being fetched are replaced with their values in turn, until no more
# substitution is necessary
#
# The URL examples from earlier in this section can be rewritten to use interpolation to make it easier to 
# change only part of the value.
# For example, this configuration file separates the protocol, hostname, and port from the URL as 
# separate options.
#



#####
#[bug_tracker]
#protocol = http
#server = localhost
#port = 8080
#url = %(protocol)s://%(server)s:%(port)s/bugs/
#username = dhellmann
#password = SECRET
#
# Interpolation is performed by default each time get() is called.
# Pass a true value in the 'raw' argument to retrieve the original value, without interpolation.
#
from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('interpolation.ini')

print('Original value       :', parser.get('bug_tracker', 'url'))
parser.set('bug_tracker', 'port', '9000')
print('Altered port value   :', parser.get('bug_tracker', 'url'))

print('Without interpolation:', parser.get('bug_tracker', 'url', raw=True))

# USING DEFAULTS
# Values for interpolation do not need to appear in the same section as the original option.
# Defauls can be mixed with override values
#   
#[DEFAULT]
#url = %(protocol)s://%(server)s:%(port)s/bugs/
#protocol = http
#server = bugs.example.com
#port = 80
#
#[bug_tracker]
#server = localhost
#port = 8080
#username = dhellmann
#password = SECRET
#
# The url value comes from the DEFAULT section, and th esubstitution starts by lookin in 'bug_tracker' 
# and falling back to DEFAULT for pieces not found.
#
from __future__ import print_function
from ConfigParser import SafeConfigParser

parser = SafeConfigParser()
parser.read('interpolation_defaults.ini')

print('URL: ', parser.get('bug_tracker', 'url'))

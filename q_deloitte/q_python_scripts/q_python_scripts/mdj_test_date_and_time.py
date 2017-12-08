
# -*- coding: utf-8 -*-
#'''
#  %a  Locale’s abbreviated weekday name.
#    %A  Locale’s full weekday name.      
#    %b  Locale’s abbreviated month name.     
#    %B  Locale’s full month name.
#    %c  Locale’s appropriate date and time representation.   
#    %d  Day of the month as a decimal number [01,31].    
#    %f  Microsecond as a decimal number [0,999999], zero-padded on the left
#    %H  Hour (24-hour clock) as a decimal number [00,23].    
#    %I  Hour (12-hour clock) as a decimal number [01,12].    
#    %j  Day of the year as a decimal number [001,366].   
#    %m  Month as a decimal number [01,12].   
#    %M  Minute as a decimal number [00,59].      
#    %p  Locale’s equivalent of either AM or PM.
#    %S  Second as a decimal number [00,61].
#    %U  Week number of the year (Sunday as the first day of the week)
#    %w  Weekday as a decimal number [0(Sunday),6].   
#    %W  Week number of the year (Monday as the first day of the week)
#    %x  Locale’s appropriate date representation.    
#    %X  Locale’s appropriate time representation.    
#    %y  Year without century as a decimal number [00,99].    
#    %Y  Year with century as a decimal number.   
#    %z  UTC offset in the form +HHMM or -HHMM.
#    %Z  Time zone name (empty string if the object is naive).    
#    %%  A literal '%' character.
#This is what we can do with the datetime and time modules in Python
#'''

import time
import datetime

print "Time in seconds since the epoch: %s" %time.time()
print "Current date and time: " , datetime.datetime.now()
print "Or like this: " ,datetime.datetime.now().strftime("%y-%m-%d-%H-%M")

print "Current year: ", datetime.date.today().strftime("%Y")
print "Month of year: ", datetime.date.today().strftime("%B")
print "Week number of the year: ", datetime.date.today().strftime("%W")
print "Weekday of the week: ", datetime.date.today().strftime("%w")
print "Day of year: ", datetime.date.today().strftime("%j")
print "Day of the month : ", datetime.date.today().strftime("%d")
print "Day of week: ", datetime.date.today().strftime("%A")

print "Or like this: " ,datetime.datetime.now().strftime("%Y%m%d_%H%M%S.%f")

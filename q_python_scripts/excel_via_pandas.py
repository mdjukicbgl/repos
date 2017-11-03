#!/usr/bin/env python

# import modules
from __future__ import print_function
import sys
import pandas as pd

# define xls to read
filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\example.xlsx"

# load the sheet into the Pandas Dataframe structure
df = pd.read_excel(filename, sheetname='Sheet1')

# View the excel file's sheet names
#print("xls_file sheet names-->%s" %(xls_file.sheet_names))
# xls_file sheet names-->[u'Sheet1', u'Sheet2', u'Sheet3']

# Load the xls file's Sheet1 as a dataframe
#df = xls_file.parse('Sheet1')

print("The list of row indicies")
print(df.index)
print("The column headings")
print(df.columns)

print("The 'fruit' column information:")
print(df['fruit'])

total = 0
# print each row of the patient column
for i in df.index:
    print(df['fruit'][i], df['count'][i])
    total += df['count'][i]

print("Total count-->%s" %(total))


"""data = df.head()

print("parsed dataframe from sheet1-->%s" %(data))

print("dataframe fruit and count-->\n%s %s" %(df['fruit'], df['count']))



data_array = data.values

print("xls dataframe-->%s" %(data_array))

#print("fruit and count-->%s %d" %(data_array['fruit'], data_array['count']))
#df
"""
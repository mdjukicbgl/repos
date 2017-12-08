import os.path
os.path.isfile(fname) 

Starting with Python 3.4, the pathlib module offers an object-oriented approach (backported to pathlib2 in Python 2.7):
from pathlib import Path

my_file = Path("/path/to/file")
if my_file.is_file():
    # file exists
To check a directory, do:
if my_file.is_dir():
    # directory exists
To check whether a Path object exists independently of whether is it a file or directory, use exists():
if my_file.exists():
    # path exists
You can also use resolve() in a try block:
try:
    my_abs_path = my_file.resolve():
except FileNotFoundError:
    # doesn't exist
else:
    # exists


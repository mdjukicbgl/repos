#/usr/local/lib/python2.7/site-packages
#!/usr/bin/env python

from __future__ import print_function

import os, sys

def main(args):

	print(sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "lib")) )

	print(sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "vendor")) )

	print(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

	print(os.path.abspath(os.path.join(os.path.dirname(__file__), 'lib')))

	print(os.path.dirname(__file__))
	
	print(os.path.realpath(__file__))

	sys.path.append('/usr/local/lib/python2.7/site-packages')

	print(sys.path)






if __name__ == '__main__':
	main(sys.argv[1:])



#	path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
#if not path in sys.path:
#    sys.path.insert(1, path)
#del path


mdjukic@uk179494:/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts : cd /usr/local/lib/python2.7/site-packages/psycopg2
mdjukic@uk179494:/usr/local/lib/python2.7/site-packages/psycopg2 : otool -L _psycopg.so
_psycopg.so:
	@loader_path/.dylibs/libpq.5.8.dylib (compatibility version 5.0.0, current version 5.8.0)
	/usr/lib/libssl.0.9.8.dylib (compatibility version 0.9.8, current version 0.9.8)
	/usr/lib/libcrypto.0.9.8.dylib (compatibility version 0.9.8, current version 0.9.8)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1226.10.1)

$ install_name_tool -change @executable_path/../lib/libssl.1.0.0.dylib /usr/local/opt/openssl/lib/libssl.1.0.0.dylib _psycopg.so

install_name_tool -change @loader_path/.dylibs/libpq.5.8.dylib /usr/lib/libssl.0.9.8.dylib /usr/lib/libcrypto.0.9.8.dylib /usr/lib/libSystem.B.dylib  _psycopg.so





sudo cp /Applications/Postgres.app/Contents/Versions/9.3/lib/libssl.1.0.0.dylib /usr/lib
sudo ln -fs /usr/lib/libssl.1.0.0.dylib /usr/lib/libssl.dylib 


sudo cp /Applications/Postgres.app/Contents/Versions/9.3/lib/libssl.1.0.0.dylib /usr/lib
sudo ln -fs /usr/lib/libssl.1.0.0.dylib /usr/lib/libssl.dylib 

sudo cp /Applications/Postgres.app/Contents/Versions/9.3/lib/libcrypto.1.0.0.dylib /usr/lib
sudo ln -fs /usr/lib/libcrypto.1.0.0.dylib /usr/lib/libcrypto.dylib 



/usr/local/lib/python2.7/site-packages/psycopg2


sudo install_name_tool -change libpq.5.dylib /Library/PostgreSQL/9.3/lib/libpq.5.dylib  /Library/Python/2.7/site-packages/psycopg2/_psycopg.so
sudo install_name_tool -change libssl.1.0.0.dylib /Library/PostgreSQL/9.3/lib/libssl.1.0.0.dylib  /Library/Python/2.7/site-packages/psycopg2/_psycopg.so
sudo install_name_tool -change libcrypto.1.0.0.dylib /Library/PostgreSQL/9.3/lib/libcrypto.1.0.0.dylib  /Library/Python/2.7/site-packages/psycopg2/_psycopg.so


sudo install_name_tool -change libpq.5.dylib /Library/PostgreSQL/9.6.3/lib/libpq.5.dylib            /usr/local/lib/python2.7/site-packages/psycopg2/_psycopg.so
sudo install_name_tool -change libssl.1.0.0.dylib /Library/PostgreSQL/9.6.3/lib/libssl.1.0.0.dylib  /usr/local/lib/python2.7/site-packages/psycopg2/_psycopg.so
sudo install_name_tool -change libcrypto.1.0.0.dylib /Library/PostgreSQL/9.6.3/lib/libcrypto.1.0.0.dylib  /usr/local/lib/python2.7/site-packages/psycopg2/_psycopg.so



sudo install_name_tool -change libpq.5.dylib /Library/PostgreSQL/9.6.3/lib/libpq.5.dylib /usr/local/lib/python2.7/site-packages/psycopg2/_psycopg.so

 sudo ln -s /Library/PostgreSQL/9.6.3/lib/libssl.1.0.0.dylib /usr/lib
 sudo ln -s /Library/PostgreSQL/9.6.3/lib/libcrypto.1.0.0.dylib /usr/lib


export DYLD_LIBRARY_PATH=/Library/PostgreSQL/9.6.3/lib
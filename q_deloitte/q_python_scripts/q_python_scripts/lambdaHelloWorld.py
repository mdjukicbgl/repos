#from __future__ import print_function
#
#import sys
#import json
##from types import SimpleNamespace as Namespace
#
#print('Loading function')
#
##event = '{ "key3": "value3", "key2": "value2",  "key1": "value1"}'
##
##context = ""
##
##def main(args):
##	print('output from lambda_handler:', lambda_handler(event, context) )
##
##
##def lambda_handler(event, context):
##    #print("Received event: " + json.dumps(event, indent=2))
##    print("value1 = " + event['key1'])
##    print("value2 = " + event['key2'])
##    print("value3 = " + event['key3'])
##    return event['key1']  # Echo back the first key value
##    #raise Exception('Something went wrong')
##
##if __name__ == '__main__':
##	main(sys.argv[1:])
##
#
##from __future__ import print_function
#import json
#
#try:
#    from types import SimpleNamespace as Namespace
#except ImportError:
#    # Python 2.x fallback
#    from argparse import Namespace
#
#data = '{"name": "John Smith", "hometown": {"name": "New York", "id": 123}}'
#
#rec = json.loads(data, object_hook=lambda d: Namespace(**d))
#
#print (rec.name, rec.hometown.name, rec.hometown.id)
#
#######################
#
#def _json_object_hook(d): 
#	return namedtuple('X', d.keys())(*d.values())
#
#def load_data(file_name):
#  with open(file_name, 'r') as file_data:
#    return file_data.read().replace('\n', '')
#
#def json2obj(file_name): 
#	return json.loads(load_data(file_name), object_hook=_json_object_hook)
#
#######################
#
#import json
#from pprint import pprint
#
#with open('data.json') as data_file:    
#    rec = json.load(data_file)
#
#pprint(rec)
########################
# amended the above to read as follows
#from __future__ import print_function
#import json
#from pprint import pprint
#try:
#    from types import SimpleNamespace as Namespace
#except ImportError:
#    # Python 2.x fallback
#    from argparse import Namespace###

#with open('C:\Users\mdjuk\q_json\data.json') as data_file:
# 	#rec = data_file.read().replace('\n', '')
#	rec = json.load(data_file)
	#rec = json.loads(data_file, object_hook=lambda d: Namespace(**d))

	#print (rec.name, rec.hometown.name, rec.hometown.id)

#    return file_data.read().replace('\n', '')
	#print (rec.name, rec.hometown.name, rec.hometown.id)


####
# data = '{"name": "John Smith", "hometown": {"name": "New York", "id": 123}}'

#rec = json.loads(data, object_hook=lambda d: Namespace(**d))

#print (rec.name, rec.hometown.name, rec.hometown.id)
####

###############

#from __future__ import print_function
#import json
#import sys
###from pprint import pprint
##
##with open('C:\Users\mdjuk\q_json\data.json') as json_data:
##    for i in range(2):
##    	print('range_no:', i)
##    	rec = json.load(json_data)
#    	print(rec)
#    	print("%s %s %s" %(rec[i]["name"], rec[i]["hometown"]["name"], rec[i]["hometown"]["id"] ))
#    

#{"business_id": "1", "Accepts Credit Cards": true, "Price Range": 1, "type": "food"} 
#{"business_id": "2", "Accepts Credit Cards": true, "Price Range": 2, "type": "cloth"} 
#{"business_id": "3", "Accepts Credit Cards": false, "Price Range": 3, "type": "sports"}

###########

#from __future__ import print_function
#import json
#
#rec = []
#i = 0
#
#with open('C:\Users\mdjuk\q_json\data.json') as f:
#    for line in f:
#        rec.append(json.loads(line))
#        i =+ 1
#        #print("%s %s %s" %(rec[i]["name"], rec[i]["hometown"]["name"], rec[i]["hometown"]["id"] ))print(rec[0]["name"], rec)
#        print(rec.home)
#
#############
#
from __future__ import print_function
import json
import codecs

recs = []

#with codecs.open('C:\Users\mdjuk\q_json\\briefs.json') as f: #, encoding='utf8') as f:
#with codecs.open('C:\Users\mdjuk\q_json\data.json') as f:
with open('C:\Users\mdjuk\q_json\data.json') as f:
    for line in f.readlines():
        recs.append(json.loads(line))

print ('print rec-->', recs)

for rec in recs:
    print (rec.keys() )
    #print (rec['hometown']['id'] )
    print("%s %s %s" %(rec["name"], rec["hometown"]["name"], rec["hometown"]["id"] ))
    

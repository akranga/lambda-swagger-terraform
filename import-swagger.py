#!/usr/bin/env python

import sys, yaml, json, os

api_id     = sys.argv[1]
input_file = sys.argv[2]

def read_json(arg):
	with open(arg, 'r') as data_file:    
		return json.load(data_file)


def read_yaml(arg):
	with open( arg, 'r') as stream:
		return yaml.load(stream)

def read_file(arg):
	if (arg.endswith('.yaml')) or (arg.endswith('.yml')):
		return read_yaml(arg)
	elif m.endswith('.json'):
		return read_json(arg)

content = read_file( input_file )
minimized = json.dumps(content)
print minimized
os.system("aws apigateway put-rest-api --rest-api-id {} --mode=merge --body='{}'".format(api_id, minimized))
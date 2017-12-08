ACCOUNT_ID = 028272314838
ROLE_NAME = ra-md-poc-lambda
FUNCTION_NAME = loadProductFile2
REGION = eu-west-1
TIMEOUT = 300
MEMORY_SIZE = 512
ZIPFILE_NAME = GenerateNewUpdate.zip
HANDLER = GenerateNewUpdate.lambda_handler

clean_pyc :
	find . | grep .pyc$ | xargs rm

install_deps :
	pip install -r requirements.txt -t ../lib
	pip install psycopg2 -t ../vendor

build : install_deps clean_pyc
	zip $(ZIPFILE_NAME) -r *
	zip $(ZIPFILE_NAME) -r ../lib/*
	zip $(ZIPFILE_NAME) -r ../vendor/*

create : build
	aws lambda create-function --region $(REGION) --function-name $(FUNCTION_NAME) --zip-file fileb://$(ZIPFILE_NAME) --role arn:aws:iam::$(ACCOUNT_ID):role/$(ROLE_NAME)  --handler $(HANDLER) --runtime python2.7 --timeout $(TIMEOUT) --memory-size $(MEMORY_SIZE)

update : build
	aws lambda update-function-code --region $(REGION) --function-name $(FUNCTION_NAME) --zip-file fileb://$(ZIPFILE_NAME)

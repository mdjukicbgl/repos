variable "remote_state_bucket"          { }
variable "remote_state_key"             { }
variable "tag_environment"              { }
variable "tag_product"                  { }
variable "lambda_file_name"             { }
variable "lambda_function_name"         { }
variable "lambda_function_handler"      { }
variable "lambda_runtime"               { }
variable "lambda_memory_size"           { }
variable "lambda_timeout"               { default = 300 }
variable "lambda_environment_variables" { 
    type = "map"
    default = { } 
}
variable "lambda_role"                  { default = "arn:aws:iam::028272314838:role/ra-md-poc-lambda" }
variable "api_name"                     { }
variable "kms_key_arn"                  { default = "arn:aws:kms:eu-west-1:028272314838:key/9aa17ab5-af34-408c-bd86-b6dc310c4615"}
variable "vpc_config_subnet_ids"        { default = ["subnet-1b4a4f6d", "subnet-8fe9eeeb"] }
variable "vpc_security_group_ids"       { default = ["sg-39448340"] }



resource "aws_lambda_function" "markdown" {
  filename = "${var.lambda_file_name}"
  function_name = "${var.lambda_function_name}"
  role = "${var.lambda_role}"
  handler = "${var.lambda_function_handler}"
  source_code_hash = "${base64sha256(file(var.lambda_file_name))}"
  runtime = "${var.lambda_runtime}"
  memory_size = "${var.lambda_memory_size}"
  vpc_config = {
    subnet_ids = "${var.vpc_config_subnet_ids}"
    security_group_ids = "${var.vpc_security_group_ids}"
  }
  kms_key_arn = "${var.kms_key_arn}"
  timeout = "${var.lambda_timeout}"

  tracing_config = {
    mode = "Active"
  }

  environment {
    variables = "${var.lambda_environment_variables}"
  }    
}


resource "aws_api_gateway_rest_api" "markdown-api" {
  name = "${var.api_name}"
}

/*
resource "aws_api_gateway_stage" "markdown-api" {
  stage_name = "dev"
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  deployment_id = "${aws_api_gateway_deployment.markdown-api.id}"
}*/


# Models
resource "aws_api_gateway_model" "markdown-api-model-build-model" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"  
  name = "Build"
  content_type = "application/json"

  schema = <<EOF
  {
    "type" : "object",
    "required" : [ "ModelId" ],
    "properties" : {
      "ModelId" : {
        "type" : "integer"
      }
    },
    "title" : "Build"    
  }
EOF
}

resource "aws_api_gateway_model" "markdown-api-scenario-calculate-model" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"  
  name = "Calculate"
  content_type = "application/json"

  schema = <<EOF
  {
    "type" : "object",
    "required" : [ "ModelId", "ModelRunId", "PartitionCount", "PartitionId", "ScenarioGuid", "ScenarioId" ],
    "properties" : {
      "ModelId" : {
        "type" : "integer"
      },
      "ModelRunId" : {
        "type" : "integer"
      },
      "ScenarioId" : {
        "type" : "integer"
      },
      "PartitionId" : {
        "type" : "integer"
      },
      "PartitionCount" : {
        "type" : "integer"
      },
      "Upload" : {
        "type" : "boolean"
      }
    },
    "title" : "Calculate"
  }
EOF
}

resource "aws_api_gateway_model" "markdown-api-scenario-prepare-model" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"  
  name = "Prepare"
  content_type = "application/json"

  schema = <<EOF
  {
    "type" : "object",
    "required" : [ "ModelId", "ModelRunId", "ScenarioId", "ScenarioGuid", "PartitionCount"],
    "properties" : {
      "ModelId" : {
        "type" : "integer"
      },
      "ModelRunId" : {
        "type" : "integer"
      },
      "ScenarioId" : {
        "type" : "integer"
      },
      "PartitionCount" : {
        "type" : "integer"
      },
      "Calculate" : {
        "type" : "boolean"
      },
      "Upload" : {
        "type" : "boolean"
      }
    },
    "title" : "Prepare"
  }
EOF
}

resource "aws_api_gateway_model" "markdown-api-scenario-upload-model" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"  
  name = "Upload"
  content_type = "application/json"

  schema = <<EOF
  {
    "type" : "object",
    "required" : [ "ScenarioId", "ScenarioGuid", "PartitionId", "PartitionCount" ],
    "properties" : {
      "ScenarioId" : {
        "type" : "integer"
      },
      "PartitionId" : {
        "type" : "integer"
      },
      "PartitionCount" : {
        "type" : "integer"
      }
    },
    "title" : "Upload"
  }
EOF
}

# Parent path
resource "aws_api_gateway_resource" "markdown-api-model" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  parent_id = "${aws_api_gateway_rest_api.markdown-api.root_resource_id}"
  path_part = "model"
}

resource "aws_api_gateway_resource" "markdown-api-scenario" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  parent_id = "${aws_api_gateway_rest_api.markdown-api.root_resource_id}"
  path_part = "scenario"
}

# Model Children
resource "aws_api_gateway_resource" "markdown-api-model-build" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  parent_id = "${aws_api_gateway_resource.markdown-api-model.id}"
  path_part = "build"
}

resource "aws_api_gateway_resource" "markdown-api-scenario-calculate" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  parent_id = "${aws_api_gateway_resource.markdown-api-scenario.id}"
  path_part = "calculate"
}

resource "aws_api_gateway_resource" "markdown-api-scenario-prepare" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  parent_id = "${aws_api_gateway_resource.markdown-api-scenario.id}"
  path_part = "prepare"
}

resource "aws_api_gateway_resource" "markdown-api-scenario-upload" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  parent_id = "${aws_api_gateway_resource.markdown-api-scenario.id}"
  path_part = "upload"
}

# Method Model/Build
resource "aws_api_gateway_method" "markdown-api-model-build-post-method" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-model-build.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true,
  request_models = { "application/json" = "${aws_api_gateway_model.markdown-api-model-build-model.name}"}
}



resource "aws_api_gateway_method_response" "markdown-api-model-build-post-method-response" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-model-build.id}"
  http_method = "${aws_api_gateway_method.markdown-api-model-build-post-method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration" "markdown-api-model-build-post-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-model-build.id}"
  http_method = "${aws_api_gateway_method.markdown-api-model-build-post-method.http_method}"
  type = "AWS"
  integration_http_method = "${aws_api_gateway_method.markdown-api-model-build-post-method.http_method}"
  uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:028272314838:function:${aws_lambda_function.markdown.function_name}/invocations"
  credentials = "arn:aws:iam::028272314838:role/ra-md-poc-lambda"
  request_parameters = {
    "integration.request.header.X-Amz-Invocation-Type" = "'Event'"
  }
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = "${file("${path.module}/markdown-api-model-build-post-integration-body-mapping.template")}"
  }  
}

resource "aws_api_gateway_integration_response" "markdown-api-model-build-post-integration-response" {
  depends_on = ["aws_api_gateway_integration.markdown-api-model-build-post-integration"]
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-model-build.id}"
  http_method = "${aws_api_gateway_method.markdown-api-model-build-post-method.http_method}"
  status_code = "${aws_api_gateway_method_response.markdown-api-model-build-post-method-response.status_code}"
}

# Method Scenario/Calculate
resource "aws_api_gateway_method" "markdown-api-scenario-calculate-post-method" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-calculate.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true,
  request_models = { "application/json" = "${aws_api_gateway_model.markdown-api-scenario-calculate-model.name}"}
}

resource "aws_api_gateway_method_response" "markdown-api-scenario-calculate-post-method-response" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-calculate.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-calculate-post-method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration" "markdown-api-scenario-calculate-post-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-calculate.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-calculate-post-method.http_method}"
  type = "AWS"
  integration_http_method = "${aws_api_gateway_method.markdown-api-scenario-calculate-post-method.http_method}"
  uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:028272314838:function:${aws_lambda_function.markdown.function_name}/invocations"
  credentials = "arn:aws:iam::028272314838:role/ra-md-poc-lambda"
  request_parameters = {
    "integration.request.header.X-Amz-Invocation-Type" = "'Event'"
  }
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = "${file("${path.module}/markdown-api-scenario-calculate-post-integration-body-mapping.template")}"
  }  
}

resource "aws_api_gateway_integration_response" "markdown-api-scenario-calculate-post-integration-response" {
  depends_on = ["aws_api_gateway_integration.markdown-api-scenario-calculate-post-integration"]
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-calculate.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-calculate-post-method.http_method}"
  status_code = "${aws_api_gateway_method_response.markdown-api-scenario-calculate-post-method-response.status_code}"
}

# Method Scenario/Prepare
resource "aws_api_gateway_method" "markdown-api-scenario-prepare-post-method" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-prepare.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true,
  request_models = { "application/json" = "${aws_api_gateway_model.markdown-api-scenario-prepare-model.name}"}
}

resource "aws_api_gateway_method_response" "markdown-api-scenario-prepare-post-method-response" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-prepare.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-prepare-post-method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration" "markdown-api-scenario-prepare-post-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-prepare.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-prepare-post-method.http_method}"
  type = "AWS"
  integration_http_method = "${aws_api_gateway_method.markdown-api-scenario-prepare-post-method.http_method}"
  uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:028272314838:function:${aws_lambda_function.markdown.function_name}/invocations"
  credentials = "arn:aws:iam::028272314838:role/ra-md-poc-lambda"
  request_parameters = {
    "integration.request.header.X-Amz-Invocation-Type" = "'Event'"
  }
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = "${file("${path.module}/markdown-api-scenario-prepare-post-integration-body-mapping.template")}"
  }  
}

# Method Scenario/Upload
resource "aws_api_gateway_method" "markdown-api-scenario-upload-post-method" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-upload.id}"
  http_method = "POST"
  authorization = "NONE"
  api_key_required = true,
  request_models = { "application/json" = "${aws_api_gateway_model.markdown-api-scenario-upload-model.name}"}
}

resource "aws_api_gateway_method_response" "markdown-api-scenario-upload-post-method-response" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-upload.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-upload-post-method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration" "markdown-api-scenario-upload-post-integration" {
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-upload.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-upload-post-method.http_method}"
  type = "AWS"
  integration_http_method = "${aws_api_gateway_method.markdown-api-scenario-upload-post-method.http_method}"
  uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:028272314838:function:${aws_lambda_function.markdown.function_name}/invocations"
  credentials = "arn:aws:iam::028272314838:role/ra-md-poc-lambda"
  request_parameters = {
    "integration.request.header.X-Amz-Invocation-Type" = "'Event'"
  }
  passthrough_behavior = "NEVER"
  request_templates = {
    "application/json" = "${file("${path.module}/markdown-api-scenario-upload-post-integration-body-mapping.template")}"
  }  
}

resource "aws_api_gateway_integration_response" "markdown-api-scenario-upload-post-integration-response" {
  depends_on = ["aws_api_gateway_integration.markdown-api-scenario-upload-post-integration"]
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  resource_id = "${aws_api_gateway_resource.markdown-api-scenario-upload.id}"
  http_method = "${aws_api_gateway_method.markdown-api-scenario-upload-post-method.http_method}"
  status_code = "${aws_api_gateway_method_response.markdown-api-scenario-upload-post-method-response.status_code}"
}

# Deployment
resource "aws_api_gateway_deployment" "markdown-api" {
  depends_on = ["aws_api_gateway_integration.markdown-api-scenario-upload-post-integration", 
                "aws_api_gateway_integration.markdown-api-scenario-prepare-post-integration", 
                "aws_api_gateway_integration.markdown-api-scenario-calculate-post-integration",
                "aws_api_gateway_integration.markdown-api-model-build-post-integration",
                "aws_api_gateway_method.markdown-api-scenario-upload-post-method",
                "aws_api_gateway_method.markdown-api-scenario-prepare-post-method",
                "aws_api_gateway_method.markdown-api-scenario-calculate-post-method",
                "aws_api_gateway_method.markdown-api-model-build-post-method",                                                
                ]
  rest_api_id = "${aws_api_gateway_rest_api.markdown-api.id}"
  stage_name = "dev"
}

output "api_gateway_base_url" {
    value = "${aws_api_gateway_deployment.markdown-api.invoke_url}"
}

output "api_gateway_execution_arn" {
    value = "${aws_api_gateway_deployment.markdown-api.execution_arn}"
}

output "lambda_function_name" {
  value = "${aws_lambda_function.markdown.function_name}"
}
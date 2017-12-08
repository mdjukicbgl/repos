variable "website_s3_bucket" {
    default = "retailax-web-dev"
}

variable "remote_state_bucket_name" {
    default = "tf-state-dcuk039-retail-ax"
}

variable "remote_state_key_name" {
    default = "dev/terraform.tfstate"
}

provider "aws" {
    region = "eu-west-1"
}

# The ACM certificate must be in US-EAST-1. SRC : https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#viewer-certificate-arguments
variable "acm_certificate_arn_us_east_one" { 
  default = "arn:aws:acm:us-east-1:028272314838:certificate/e5ada1ab-899f-4d15-b47f-590a0709d660"
}

variable "acm_certificate_arn_eu_west_one" { 
  default = "arn:aws:acm:eu-west-1:028272314838:certificate/9ba58365-4a0b-4e30-8658-67d4aea1425c"
}

variable "website_url"                  { 
  default = "deloitteretailanalytics.deloittecloud.co.uk"
}

variable "route53_private_zone_id"                  { 
  default = "Z3A14883DOPYTJ"
}

variable "route53_public_zone_id"                  { 
  default = "Z3PIWRHTTFLT4D"
}

variable "public_subnets"             { default = ["subnet-1a4a4f6c","subnet-88e9eeec"] }
variable "private_subnets"             { default = ["subnet-1a4a4f6c","subnet-88e9eeec"] }

terraform {
  backend "s3" {
    bucket = "tf-state-dcuk039-retail-ax"
    key = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "website" {
    source = "../modules/website"

    website_bucket_name             = "${var.website_s3_bucket}"
    remote_state_bucket             = "${var.remote_state_bucket_name}"
    remote_state_key                = "${var.remote_state_key_name}"
    acm_certificate_arn             = "${var.acm_certificate_arn_us_east_one}"
    website_url                     = "${var.website_url}"
    route53_zone_id                 = "${var.route53_private_zone_id}"

    tag_environment                 = "dev"
    tag_product                     = "retailax"
}

module "api" {
    source                          = "../modules/api"

    api_key_name                    = "pf-retailax-dev"

    remote_state_bucket             = "${var.remote_state_bucket_name}"
    remote_state_key                = "${var.remote_state_key_name}"
    acm_certificate_arn             = "${var.acm_certificate_arn_eu_west_one}"
    website_url                     = "${var.website_url}"
    route53_zone_id                 = "${var.route53_private_zone_id}"
    subnets                         = "${var.private_subnets}"

    tag_environment                 = "dev"
    tag_product                     = "retailax"    

}

module "app_db" {
    source                          = "../modules/db"

    remote_state_bucket             = "${var.remote_state_bucket_name}"
    remote_state_key                = "${var.remote_state_key_name}"

    tag_environment                 = "dev"
    tag_product                     = "retailax"    

    database_id                     = "retailax-db-app-dev"
    database_name                   = "app"
    username                        = "retailaxappdev"
    password                        = "XfQCD9VgZdpyYmvF"
    vpc_security_group_id           = "sg-e77c4781"
    subnet_group_name               = "default-vpc-9e1626fa"
}

#
#module "model_db" {
#    source                          = "../modules/db"
#
#    remote_state_bucket             = "${var.remote_state_bucket_name}"
#    remote_state_key                = "${var.remote_state_key_name}"
#
#    tag_environment                 = "dev"
#    tag_product                     = "retailax"    
#
#    database_id                     = "retailax-db-model-dev"
#    database_name                   = "app"
#    username                        = "retailaxmodeldev"
#    password                        = "8D9gPM8thNYc2xvv"
#    vpc_security_group_id           = "sg-e77c4781"
#    subnet_group_name               = "default-vpc-9e1626fa"
#}

module "model_processor" {
    source                          = "../modules/markdown-model"

    remote_state_bucket             = "${var.remote_state_bucket_name}"
    remote_state_key                = "${var.remote_state_key_name}"

    tag_environment                 = "dev"
    tag_product                     = "retailax"

    lambda_file_name                = "retailax-markdown-lambda.zip"
    lambda_function_name            = "markdown-processor"
    lambda_function_handler         = "Markdown.App::Markdown.Function.Program::AWSMain"
    lambda_runtime                  = "dotnetcore1.0"
    lambda_memory_size              = 1536
    lambda_timeout                  = 300
    lambda_environment_variables    = { 
      ASPNETCORE_ENVIRONMENT = "Development",
      AppConnection = "Host=${module.app_db.address};Username=${module.app_db.username};Password=${module.app_db.password};Database=${module.app_db.database};Pooling=false;CommandTimeout=240"
      EphemeralConnection = "Host=${module.app_db.address};Username=${module.app_db.username};Password=${module.app_db.password};Database=${module.app_db.database};Pooling=false;CommandTimeout=240;"
      S3ModelBucketName = "ra-md-poc-dcuk039"
      S3ScenarioBucketName = "ra-md-poc-dcuk039"        
    }

    api_name                        = "markdown-model-api"

}

output "app_db_endpoint" {
    value = "${module.app_db.endpoint}"
}

output "app_db_address" {
    value = "${module.app_db.address}"
}

output "app_db_port" {
    value = "${module.app_db.port}"
}

output "app_db_username" {
    value = "${module.app_db.username}"
}

output "app_db_password" {
    value = "${module.app_db.password}"
}

output "app_db_database" {
    value = "${module.app_db.database}"
}

output "app_db_default_database" {
    value = "${module.app_db.default_database}"
}


/*
output "model_db_endpoint" {
    value = "${module.model_db.endpoint}"
}

output "model_db_address" {
    value = "${module.model_db.address}"
}

output "model_db_port" {
    value = "${module.model_db.port}"
}

output "model_db_username" {
    value = "${module.model_db.username}"
}

output "model_db_password" {
    value = "${module.model_db.password}"
}

output "model_db_database" {
    value = "${module.model_db.database}"
}*/

output "model_processor_api_gateway_base_url" {
    value = "${module.model_processor.api_gateway_base_url}"
}

output "website_endpoint" {
    value = "${module.website.website_endpoint}"
}

output "model_processor_lambda_function_name" {
    value = "${module.model_processor.lambda_function_name}"
}

output "api_private_ip" {
    value = "${module.api.api_private_ip}"
}
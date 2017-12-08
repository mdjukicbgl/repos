variable "remote_state_bucket"          { }
variable "remote_state_key"             { }
variable "tag_environment"              { }
variable "tag_product"                  { }
variable "engine"                       { default = "postgres" }
variable "engine_version"               { default = "9.6.2" }
variable "instance_class"               { default = "db.m4.2xlarge" }
variable "username"                     { }
variable "password"                     { }
variable "vpc_security_group_id"        { }
variable "subnet_group_name"            { }
variable "database_name"                { }
variable "default_database_name"        { default = "master" }
variable "database_id"                  { }

// App Database Server
resource "aws_db_instance" "db" {
  allocated_storage = 100
  storage_type = "gp2"
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  instance_class = "${var.instance_class}"
  identifier = "${var.database_id}"
  final_snapshot_identifier = "${var.database_id}"
  name = "${var.default_database_name}"
  username = "${var.username}"
  password = "${var.password}"
  vpc_security_group_ids = ["${var.vpc_security_group_id}"]
  db_subnet_group_name = "${var.subnet_group_name}"
  skip_final_snapshot = true
  availability_zone = "eu-west-1b"

  tags {
    Name = "${var.tag_product}-db-${var.tag_environment}"
    Product = "${var.tag_product}"
    Environment = "${var.tag_environment}"
  }  
}

output "endpoint" {
  value = "${aws_db_instance.db.endpoint}"
}

output "address" {
  value = "${aws_db_instance.db.address}"
}

output "port" {
  value = "${aws_db_instance.db.port}"
}

output "username" {
  value = "${aws_db_instance.db.username}"
}

output "password" {
  value = "${aws_db_instance.db.password}"
}

output "default_database" {
  value = "${aws_db_instance.db.name}"
}

output "database" {
  value = "${var.database_name}"
}

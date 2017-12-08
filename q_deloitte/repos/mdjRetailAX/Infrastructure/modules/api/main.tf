#----------------------------------------------------------------
# This module creates the ec2 instance to host the web api
#----------------------------------------------------------------

variable "api_ami"                    { default = "ami-a8d2d7ce" }
variable "api_instance_type"          { default = "t2.micro" }
variable "api_availability_zone"      { default = "eu-west-1a" }
variable "api_key_name"               { }
variable "api_subnet_id"              { default = "subnet-8fe9eeeb" }
variable "api_vpc_security_group_id"  { default = "sg-142db46d" }
variable "api_vpc_id"                 { default = "vpc-9e1626fa" }
variable "api_private_ip"             { default = "172.20.21.50" }
variable "api_private_key_file"       { default = "pf-retailax-dev.pem" }
variable "subnets"                    { default = [] }
variable "route53_zone_id"            { }
variable "remote_state_bucket"        { }
variable "remote_state_key"           { }
variable "tag_environment"            { }
variable "tag_product"                { }
variable "acm_certificate_arn"        { }
variable "website_url"                { }

resource "aws_instance" "api" {
  ami = "${var.api_ami}"
  instance_type = "${var.api_instance_type}"
  associate_public_ip_address = "false"
  availability_zone = "${var.api_availability_zone}"
  key_name = "${var.api_key_name}"
  
  source_dest_check = true

  subnet_id = "${var.api_subnet_id}"

  vpc_security_group_ids = ["${var.api_vpc_security_group_id}"]

  private_ip = "${var.api_private_ip}"

  root_block_device {
    volume_size = "8"
    delete_on_termination = "true"
  }

  tags {
    Name = "${var.tag_product}-api-${var.tag_environment}"
    Product = "${var.tag_product}"
    Environment = "${var.tag_environment}"
  }

}

data "terraform_remote_state" "api" {
    backend = "s3"

    config {
        bucket = "${var.remote_state_bucket}"
        key = "${var.remote_state_key}"
        region = "eu-west-1"
    }
}

resource "aws_alb" "api_alb" {
  depends_on  = ["aws_security_group.api_alb_security_group"]
  name            = "api-alb"
  internal        = true
  security_groups = ["${aws_security_group.api_alb_security_group.id}"]
  subnets         = "${var.subnets}"

  enable_deletion_protection = false

/* Need to enabled later.
  access_logs {
    bucket = "${aws_s3_bucket.alb_logs.bucket}"
    prefix = "test-alb"
  }*/

  tags {
    Name = "${var.tag_product}-api-${var.tag_environment}"
    Product = "${var.tag_product}"
    Environment = "${var.tag_environment}"
  }
}

resource "aws_alb_target_group" "api_alb_target_group" {
  name     = "tf-api-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.api_vpc_id}"
}


resource "aws_alb_target_group_attachment" "api_alb_target_group_attachment" {
  depends_on  = ["aws_alb_target_group.api_alb_target_group","aws_instance.api"]
  target_group_arn = "${aws_alb_target_group.api_alb_target_group.arn}"
  target_id        = "${aws_instance.api.id}"
  port             = 80
}

resource "aws_alb_listener" "api_aws_alb_listener" {
  load_balancer_arn = "${aws_alb.api_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.acm_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.api_alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_route53_record" "api_aws_route53_record" {
  depends_on  = ["aws_alb.api_alb"]
  zone_id = "${var.route53_zone_id}"
  name    = "api.${var.website_url}"
  type    = "A"

  alias {
    name                   = "${aws_alb.api_alb.dns_name}"
    zone_id                = "${aws_alb.api_alb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_security_group" "api_alb_security_group" {
  name        = "api-alb-security-group"
  description = "Control inbound traffic"
  vpc_id = "${var.api_vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [ "172.31.0.0/16",
                    "10.99.0.0/16"
/*                    ,
                    "80.5.33.115/32",
                    "79.173.138.58/32",
                    "79.71.205.76/32",
                    "81.109.57.131/32",
                    "170.194.32.12/32",
                    "170.194.32.44/32",
                    "79.173.155.218/32" */
                   ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "api_private_ip" { value = "${aws_instance.api.private_ip}" }
output "API URL" { value = "api.${var.website_url}" }

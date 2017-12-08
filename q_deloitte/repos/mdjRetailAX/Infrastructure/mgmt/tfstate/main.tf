provider "aws" {
    region = "eu-west-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "tf-state-dcuk039-retail-ax"

    versioning {
        enabled = true
    }

    lifecycle {
        prevent_destroy = true
    }
}

output "s3_bucket_arn" {
    value = "${aws_s3_bucket.terraform_state.arn}"
}
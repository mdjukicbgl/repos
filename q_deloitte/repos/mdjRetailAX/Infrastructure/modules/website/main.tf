variable "website_bucket_name"          { }
variable "remote_state_bucket"          { }
variable "remote_state_key"             { }
variable "tag_environment"              { }
variable "tag_product"                  { }
#variable "logs_bucket_name"            { }
variable "acm_certificate_arn"          { }
variable "website_url"                  { }
variable "route53_zone_id"              { }

resource "aws_s3_bucket" "website" {
  bucket = "${var.website_bucket_name}"
  force_destroy = true
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::retailax-web-dev/*"
      }
  ]
}
EOF

  tags {
    Name = "${var.tag_product}-s3-website-${var.tag_environment}"
    Product = "${var.tag_product}"
    Environment = "${var.tag_environment}"
  }
}


data "terraform_remote_state" "website" {
    backend = "s3"

    config {
        bucket = "${var.remote_state_bucket}"
        key = "${var.remote_state_key}"
        region = "eu-west-1"
    }
}

output "website_endpoint" {
    value = "${aws_s3_bucket.website.website_endpoint}"
}

resource "aws_waf_ipset" "ipset" {
  name = "tfIPSet"

  ip_set_descriptors = [ {
    type = "IPV4"
    value = "172.31.0.0/16"
  },
  {
    type = "IPV4"
    value = "10.99.0.0/16"
  },
  {
    type = "IPV4"
    value = "80.5.33.115/32"
  },

  {
    type = "IPV4"
    value = "79.173.138.58/32"
  },
  {
    type = "IPV4"
    value = "79.71.205.76/32"
  },
  {
    type = "IPV4"
    value = "81.109.57.131/32"
  },
  {
    type = "IPV4"
    value = "170.194.32.12/32"
  },
  {
    type = "IPV4"
    value = "170.194.32.44/32"
  },
  {
    type = "IPV4"
    value = "79.173.155.218/32"
  }
  ]
}

resource "aws_waf_rule" "wafrule" {
  depends_on  = ["aws_waf_ipset.ipset"]
  name        = "tfWAFRule"
  metric_name = "tfWAFRule"

  predicates {
    data_id = "${aws_waf_ipset.ipset.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "waf_acl" {
  depends_on  = ["aws_waf_ipset.ipset", "aws_waf_rule.wafrule"]
  name        = "tfWebACL"
  metric_name = "tfWebACL"

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = "${aws_waf_rule.wafrule.id}"
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id   = "myS3Origin"

  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "CloudFront distribution for the website"
  default_root_object = "index.html"

  aliases = ["dev.${var.website_url}"]

  web_acl_id = "${aws_waf_web_acl.waf_acl.id}"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    # One of allow-all, https-only, or redirect-to-https.
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Info on Price Classes : https://aws.amazon.com/cloudfront/pricing/
  price_class = "PriceClass_All"


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  tags {
    Environment = "Development"
  }

  viewer_certificate {
    acm_certificate_arn = "${var.acm_certificate_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"

  }

  custom_error_response = [{
    error_code              = 404
    error_caching_min_ttl   = 300
    response_code           = 200
    response_page_path      = "/index.html"
  },
  {
    error_code              = 403
    error_caching_min_ttl   = 300
    response_code           = 200
    response_page_path      = "/index.html"
  }]
}


resource "aws_route53_record" "website_aws_route53_record" {
  depends_on  = ["aws_cloudfront_distribution.s3_distribution"]
  zone_id = "${var.route53_zone_id}"
  name    = "dev.${var.website_url}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = true
  }
}

output "SPA URL" { value = "dev.${var.website_url}" }

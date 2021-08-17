terraform {
  required_version = ">=0.12"
}
provider "aws" {
  region = "us-east-1"
}
#--------------------------------------------------------#
# s3 static website
# http://my-bucket-name.s3-website-us-east-1.amazonaws.com
#--------------------------------------------------------#
resource "aws_s3_bucket" "s3" {
  bucket = "enteruniquename"
  acl = "public-read"
  policy = file("policy.json")
  website {
    index_document = "index.html"
  }
}

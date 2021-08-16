#----------------------------------------------------------#
# VPC Variables
#----------------------------------------------------------#
variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.200.0.0/16"
}
variable "public_subnet_cidr" {
  default = ["10.200.10.0/24"]
}
variable "private_subnet_cidr" {
  default = ["10.200.1.0/24"]
}
variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}
variable "all_cidr" {
  default = ["0.0.0.0/0"]
}

#----------------------------------------------------------#
# EC2 variables
#----------------------------------------------------------#

variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "SSH-using-windows"
}
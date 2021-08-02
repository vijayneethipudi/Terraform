# vpc variables
variable "region" {
    default = "us-east-1"
    description = "default region for resources"
}
variable "vpc_cidr" {
    default = "10.10.0.0/16"
    description = "vpc cidr value"
}
variable "db_subnet_cidr" {
    default = ["10.10.1.0/24", "10.10.2.0/24"]
    description = "db subnet cidr"
}
variable "public_subnet_cidr" {
    default = ["10.10.10.0/24", "10.10.11.0/24"]
    description = "public subnet cidr"
}
variable "azs" {
    default = ["us-east-1a", "us-east-1b"]
    description = "defualt availability zones"
}

# ec2 variables
variable "ami_id" {
    default = "ami-0c2b8ca1dad447f8a"
    description = "ami id"
}
variable "instance_type" {
    default = "t2.micro"
    description = "instance type"
}
variable "key_name" {
    description = "Enter key name for SSH"
}
variable "user_data" {
    default = <<EOF
        #! /bin/bash
        sudo su
        yum update -y
        yum install mysql -y 
    EOF
    description = "insatlling mysql client on ec2"
}

# rds variables
variable "engine" {
    default = "mysql"
    description = "rds engine"
}
variable "instance_class" {
    default = "db.t2.micro"
    description = "free tier engine" 
}
variable "username" {
    default = "admin"
    description = "db user name"
}
variable "password" {
    description = "enter db password"
}

#vpc variables
variable "region" {default = "us-east-1"}
variable "vpc_cidr" {default = "10.0.0.0/16"}
variable "azs" {default = ["us-east-1a", "us-east-1b"]}
variable "pbsub_cidr" {default = ["10.0.1.0/24", "10.0.2.0/24"]}
#ec2 variables
variable "ami" {default = "ami-0c2b8ca1dad447f8a"}
variable "instance_type" {default = "t2.micro"}
variable "key_name" {description = "enter you ssh key name"}
variable "user_data_B" {
    default = <<EOF
        #!/bin/bash
        sudo su
        yum update -y
        yum install httpd -y
        cd /var/www/html
        echo "<p>Hello World from Instance B</p>" > index.html
        service httpd start
    EOF
}
variable "all_cidr" {default = ["0.0.0.0/0"]}
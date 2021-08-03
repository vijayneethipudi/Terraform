terraform {
    required_version = ">= 0.12"
}
provider "aws" {
    region = var.region
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "terraform vpc"
    cidr = var.vpc_cidr
    azs = var.azs
    public_subnets = var.pbsub_cidr
    tags = {
        Terraform = true
        "Name" = "terraform vpc"
    }
}

#ec2 resources 
resource "aws_instance" "instanceA" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = "${module.vpc.public_subnets[0]}"
    security_groups = [aws_security_group.ssh.id]
    user_data = file("userdata.sh")
    tags = {
        "Name" = "instanceA"
    }
}
resource "aws_instance" "instanceB" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = "${module.vpc.public_subnets[1]}"
    security_groups = [aws_security_group.ssh.id]
    user_data = var.user_data_B
    tags = {
        "Name" = "instanceB"
    }
}

#elb resource 
resource "aws_elb" "web" {
    name = "test-elb"
    subnets = "${module.vpc.public_subnets}"
    security_groups = [aws_security_group.elb.id]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }
    #instances registered automatically

    instances = [aws_instance.instanceA.id, aws_instance.instanceB.id]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400
}

terraform {
    required_version = ">=0.12"
}
provider "aws" {
    region = "us-east-1"
}
#----------------------------------------------------------#
# VPC Module
#----------------------------------------------------------#
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    cidr = var.vpc_cidr
    azs = var.azs
    public_subnets = var.public_subnet_cidr
    private_subnets = var.private_subnet_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "POC"
        Terraform = true
    }
}
#----------------------------------------------------------#
# EC2 Latest AMI from AWS
#----------------------------------------------------------#
data "aws_ami" "latest_instance" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "owner-alias"
        values = ["amazon"]
    }
    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"]
    }
}

#----------------------------------------------------------#
# EC2 Instances
#----------------------------------------------------------#
resource "aws_instance" "public_instance" {
    ami = data.aws_ami.latest_instance.id
    instance_type = var.instance_type
    subnet_id = module.vpc.public_subnets[0]
    iam_instance_profile = aws_iam_instance_profile.AWSSSMInstanceCore.name
    security_groups = [aws_security_group.public_ec2_sg.id]
    tags = {
        "Name" = "public_instance"
    }
}
resource "aws_instance" "private_instance" {
    ami = data.aws_ami.latest_instance.id
    instance_type = var.instance_type
    subnet_id = module.vpc.private_subnets[0]
    iam_instance_profile = aws_iam_instance_profile.AWSSSMInstanceCore.name
    security_groups = [aws_security_group.private_ec2_sg.id]
    tags = {
        "Name" = "private_instance"
    }
}
#----------------------------------------------------------#
# Endpoints SSM, SSMMessages, S3Gateway
#----------------------------------------------------------#
resource "aws_vpc_endpoint" "ssmec2" {
    service_name = "com.amazonaws.${var.region}.ssm"
    vpc_id = module.vpc.vpc_id
    subnet_ids = [module.vpc.private_subnets[0]]
    vpc_endpoint_type = "Interface"
    security_group_ids = [aws_security_group.private_ec2_sg.id,]
    private_dns_enabled = true
    tags = {
        "Name" = "ssm_endpoint"
    }
}
resource "aws_vpc_endpoint" "ssmmessagesec2" {
    service_name = "com.amazonaws.${var.region}.ssmmessages"
    vpc_id = module.vpc.vpc_id
    subnet_ids = [module.vpc.private_subnets[0]]
    vpc_endpoint_type = "Interface"
    security_group_ids = [aws_security_group.private_ec2_sg.id,]
    private_dns_enabled = true
    tags = {
        "Name" = "ssm_messages_endpoint"
    }
}
resource "aws_vpc_endpoint" "s3gateway_ec2" {
    service_name = "com.amazonaws.${var.region}.s3"
    vpc_id = module.vpc.vpc_id
    tags = {
        "Name" = "s3_gateway_endpoint"
    }
}
resource "aws_vpc_endpoint_route_table_association" "private_route_table_association_s3" {
    route_table_id = module.vpc.private_route_table_ids[0]
    vpc_endpoint_id = aws_vpc_endpoint.s3gateway_ec2.id
}
resource "aws_vpc_endpoint_route_table_association" "public_route_table_association_s3" {
    route_table_id = module.vpc.public_route_table_ids[0]
    vpc_endpoint_id = aws_vpc_endpoint.s3gateway_ec2.id
}
#----------------------------------------------------------#
# Outputs
#----------------------------------------------------------#
output "vpc_id"{
    value = module.vpc.vpc_id
}
output "private_subnets" {
    value = module.vpc.private_subnets
}
output "public_subnets" {
    value = module.vpc.public_subnets
}
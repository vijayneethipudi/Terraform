terraform {
  required_version = ">= 0.12"
}
provider "aws" {
    region = var.region
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    
    name = "test-vpc"
    cidr = var.vpc_cidr
    azs = var.azs
    private_subnets = var.db_subnet_cidr
    public_subnets = var.public_subnet_cidr   
    tags = {
        Terraform = true
        Name = "terraform vpc"
    }
}

resource "aws_db_subnet_group" "dbsubnet" {
    name = "dbsubnet"
    subnet_ids = module.vpc.private_subnets
    tags = {
      "Name" = "db_subnetgroup"
    }
}
resource "aws_db_instance" "mysqlinstance" {
    allocated_storage = 10
    engine = var.engine
    engine_version = "5.7"
    instance_class = var.instance_class
    name = "mydB"
    username = var.username
    password = var.password
    db_subnet_group_name = aws_db_subnet_group.dbsubnet.id
    multi_az = false
    skip_final_snapshot = true 
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

output "dbaddress" {
    value = aws_db_instance.mysqlinstance.address
}
output "dbendpoint" {
    value = aws_db_instance.mysqlinstance.endpoint
}
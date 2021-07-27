terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.00"
        }
    }
}

provider "aws" {
    profile = "default"
    region = "us-east-1"
}

# resource "aws_vpc" "testvpc" {
#     cidr_block = "10.10.0.0/16"
#     enable_dns_support = true
#     enable_dns_hostnames = true
#     tags = {
#         Name = "testvpc"
#     }
# }

# resource "aws_subnet" "publicSubnet" {
#     cidr_block = "10.10.10.0/24"
#     vpc_id = aws_vpc.testvpc.id
#     availability_zone = "us-east-1a"
#     map_public_ip_on_launch = true
#     tags = {
#       "Name" = "Public Subnet"
#     }
# }
# resource "aws_subnet" "privateSubnet" {
#     cidr_block = "10.10.11.0/24"
#     vpc_id = aws_vpc.testvpc.id
#     availability_zone = "us-east-1a"
#     tags = {
#       "Name" = "Private Subnet"
#     }
# }

resource "aws_iam_role" "test_role" {
    name = "test_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = "sts:AssumeRole"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })

    tags = {
      "Name" = "Terraform-first-Role"
    }
}

resource "aws_iam_policy" "s3testpolicy" {
    name = "test_policy"
    path = "/"
    description = "My test policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:*"
                ]
                Effect = "Allow"
                Resource = "*"
            },
        ]
    })
}
resource "aws_iam_role_policy_attachment" "test-attach" {
    role = aws_iam_role.test_role.name
    policy_arn = aws_iam_policy.s3testpolicy.arn
}

resource "aws_iam_instance_profile" "test_profile" {
    name = "test_profile"
    role = aws_iam_role.test_role.name
}
resource "aws_instance" "test_instance" {
    ami =  "ami-0dc2d3e4c0f9ebd18"
    instance_type = "t2.micro"
    iam_instance_profile = aws_iam_instance_profile.test_profile.name
    key_name = "SSH-using-windows"
    vpc_security_group_ids = [aws_security_group.sshgroup.id]
    tags = {
        Name = "Test_EC2Instance"
    }
}
resource "aws_security_group" "sshgroup" {
    name = "allow_ssh"
    description = "Allow SSH inbound traffic"
    
    ingress {
        description = "SSH from my IP"
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      "Name" = "allow SSH"
    }
}
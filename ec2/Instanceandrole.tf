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

# This template creates 6 resoures
# 1 IAM role,
# 1 IAM policy, 
# 1 Attach the policy and role, 
# 1 Instance Profile,
# 1 EC2 instance, 
# 1 Security group

# S3 full access policy is attached to the IAM role and ec2 instance assume the role to access s3 bucket via public internet

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
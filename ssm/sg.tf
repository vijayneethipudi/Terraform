#----------------------------------------------------------#
# Security Groups
#----------------------------------------------------------#
resource "aws_security_group" "public_ec2_sg" {
  name        = "allow ssh"
  description = "Allow SSH from anywhere"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = var.all_cidr
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = var.all_cidr
  }
  tags = {
    "Name" = "terraform_ec2sg"
  }
}

resource "aws_security_group" "private_ec2_sg" {
  name        = "allow https"
  description = "Allow HTTPS from anywhere"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = var.all_cidr
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = var.all_cidr
  }
}
resource "aws_security_group" "ec2_sg" {
    name = "allow SSH"
    description = "Allow SSH from anywhere"
    vpc_id = "${module.vpc.vpc_id}"

    ingress {
        description = "SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      "Name" = "terraform_ec2sg"
    }
}
resource "aws_security_group" "rds_sg" {
    name = "allow ec2 to rds"
    description = "Allow ec2 to rds group"
    vpc_id = "${module.vpc.vpc_id}"

    ingress {
        description = "allow ec2 to rds"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.ec2_sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      "Name" = "terraform_rdssg"
    }
}
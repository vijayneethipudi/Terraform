resource "aws_security_group" "ssh" {
    name = "ssh security group" 
    description = "allow ssh into the ec2 instance"
    vpc_id = "${module.vpc.vpc_id}"

    ingress {
        description = "allow ssh connection from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.all_cidr 
    }
    ingress {
        description = "allow http communication for elb to ec2"
        from_port = 80
        to_port = 80
        protocol ="tcp"
        security_groups = [aws_security_group.elb.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.all_cidr
    }
    tags = {
        "Name"="terraform_ec2sg"
    }
}
resource "aws_security_group" "elb" {
    name = "elb security group"
    description = "allow port 80 communication"
    vpc_id = "${module.vpc.vpc_id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol= "tcp"
        cidr_blocks = var.all_cidr
    }
    egress {
        from_port= 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.all_cidr
    }
    tags = {
        "Name" = "terrafrom_ebl_sg"
    }
}
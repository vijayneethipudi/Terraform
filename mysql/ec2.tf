resource "aws_instance" "ec2_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    security_groups = [aws_security_group.ec2_sg.id]
    key_name = var.key_name
    subnet_id = "${module.vpc.public_subnets[0]}"
    user_data = var.user_data
    tags = {
      "Name" = "ec2_instance"
    }
}
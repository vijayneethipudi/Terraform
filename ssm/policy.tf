#----------------------------------------------------------#
# IAM Policies and Roles
#----------------------------------------------------------#
data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_role_attachment" {
  policy_arn = data.aws_iam_policy.ssm.arn
  role = aws_iam_role.ssm_role.name
}
resource "aws_iam_role_policy_attachment" "s3_role_attachment" {
  policy_arn = data.aws_iam_policy.s3_full_access.arn
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_instance_profile" "AWSSSMInstanceCore" {
  name = "AWSSSMInstanceCore"
  role = aws_iam_role.ssm_role.name
}
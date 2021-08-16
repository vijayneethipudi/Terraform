#Connect to Private Instance without Bastion host

We can connect to Private EC2 instance without a Bastion host usually resides in the public subnet.

We need below requirements to successfully connect to private instance using `ssm`
1. SSM Role (AmazonSSMManagedInstanceCore)
2. Interface Endpoints 
   1. ssm
   2. ssmmessages
   
When you are creating interface endpoints ensure to select the private subnets and private instance security groups

Below terraform files will help you provision the infrastructure. Once the infrastructure is deployed, login to aws console, navigate to ssm console.

under the left side navigation pane, select `Fleet Manager` under `Node Management`. You should see 2 instances, public instance and private instance => click on private instance (radio button) and select instance actions => connect. It will open a new window shell, from there type aws s3 ls -> it will yield you all the s3 buckets lists(I also created s3 gateway endpoint and attached proper IAM policy to the instances so that they will able to access the bucket list). 

`variables.tf` => Make sure to enter your region of choice in variables.tf file.

`sg.tf` => security group rules, contains below rules
1. Allowing ssh for public instance
2. Allowing HTTPS traffic for private instance

`policy.tf` => Role, IAM policy, Instance Profile details, in the template I am using the aws managed policies with arn values.
`arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore`, `arn:aws:iam::aws:policy/AmazonS3FullAccess`

`main.tf` =>
1. VPC Module
    1. Public subnet
    2. Private subnet
    3. Route tables
    4. IGW
    5. Route tables
2. Public Instance
   1. instance ami value was fetched from the amazon 
3. Private Instance
4. Endpoints
   1. VPC Gateway Endpoints
      1. s3
   2. VPC Interface Endpoints
      1. ssm
      2. ssmmessages


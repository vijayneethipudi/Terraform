# ELB
---
This template will launch 2 ec2 instances (A/B) and ELB loadbalancer.

To launch the template us below command 

`terraform apply -var="key_name=entersshkeyname"` 

Once the template is launched,
    
    -> go to ec2 console 
    -> under left navigation pane 
    -> click on load balancers 
    -> copy the dns A record of the load balancer.

Navigate to the copied url and you should be seeing
Hello world from instance A/B.

Keep refreshing the page and you will see the load balanacer is sending the requests to both servers.


## Terraform commands
---
To apply your changes in the terraform partially to just a single resource use below command

`terraform apply --target=aws_resource.name`

    here aws_resource is like aws_instance

    name is what you enter the following aws_instance when you create resource.

If you don't want to enter yes everytime you run apply command, simply send auto-approve flag 

`terraform apply --auto-approve`
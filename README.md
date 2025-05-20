# AWS Jump Host

A simple repo for AWS Jumphost provisioning
## Features
Terraform code for provisioning a simple AWS EC2 to be used as Jump Host. Uses EC2 spot instance to reduce cost.

## Tech
- Default VPC and Subnet
- Custom security group with inbound on 22 and all outbound
- Using terraform aws_instance resource and EC2_spot requests
- Get latest AL2023 ARM64 AMI (make sure you are using Graviton Instance type)
- Custom userdata provisionied through file
- Uses kyepair for ssh

## Installation
Install terraform and dependencies. Run Terraform commands

```sh
terraform init
terraform plan
terraform apply --auto-approve
```

For accessing the EC2

```sh
ssh -i <Your_key_pair_path>/<Your_key>.pem ec2-user@<Your_EC2_IP>
```
## Cleanup

```sh
terraform destroy --auto-approve
```

## License

**Free Software, Hell Yeah! Use as you wish**

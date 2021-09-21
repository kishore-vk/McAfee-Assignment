# Testing Terraform Modules

This repo is to test out Terraform Modules
---

## Requirements
- You have access to AWS Key pair or create one before executing the module
- Have your AWS Credentials configured
- Tested on Terraform `0.14.11`
- Nginx Image in ECR repo
---

## Resources created
This module creates below AWS resources

| Resource List   |
|-----------------|
| ASG             |
| Launch Template |
| ECS cluster     |
| ECS service     |
| EC2 IAM role    |
| ECS IAM role    |
| S3 Bucket       |
---

## How to use?
- Update required region and profile in `main.tf`
- Use `vpc.tf` to spin a new VPC with Public and Private subnet
- Declare module and provider in `asg.tf`
- Spin a new ALB and TG thru `alb-tg.tf`
- Make changes in `variables.tf` as per your needs
---

## Yet to do
- Configure ECS and ECR
- S3 and Nginx config

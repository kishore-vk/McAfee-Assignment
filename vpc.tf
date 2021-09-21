module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "web-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Name      = "web-vpc"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "web-sg"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "web-sg"
  }
}

resource "aws_security_group_rule" "web_to_http" {
  type            = "egress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-sg.id
  description     = "HTTP to anywhere"
}

resource "aws_security_group_rule" "web_to_https" {
  type            = "egress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-sg.id
  description     = "HTTP to anywhere"
}

resource "aws_security_group_rule" "ssh_from_anywhere" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-sg.id
  description     = "SSH from anywhere"
}

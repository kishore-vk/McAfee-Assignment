variable "application_name" {
	default = "moduletest"
}

variable "image_id" {
	default = "ami-0b8087b9a726c87de"
}

variable "instance_type" {
	default = "t3.medium"
}

variable "key" {
	default = "turbot"
}

data "aws_security_group" "sg" {
  tags = {
    Name = "web-sg"
  }
	depends_on = [ aws_security_group_rule.ssh_from_anywhere ]
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["web-vpc"]
  }
	depends_on = [ module.vpc.vpc_id ]

}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["web-vpc"]
  }
}

variable "desired_capacity" {
	default = "2"
}

variable "min_size" {
	default = "1"
}

variable "max_size" {
	default = "2"
}

# VPC arguments
variable "region" {
	default = ""
}

# Launch template varaibles
variable "application_name" {
  description = "Name of your application. Required"
  type        = string
}

variable "image_id" {
  description = "Enter the AWS AMI ID. Required"
  type        = string
}

variable "instance_type" {
  description = "AWS Instance Type. Required"
  type        = string
}

variable "key" {
  description = "AWS Instance Key. Required"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

# ASG variables
variable "subnets" {
  description = "List of subnet ID's"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Name of your application. Required"
  type        = number
}

variable "max_size" {
  description = "Name of your application. Required"
  type        = number
}

variable "min_size" {
  description = "Name of your application. Required"
  type        = number
}

variable "container_insights" {
  description = "To Enable container insights. Boolean. Required"
  type        = bool
  default     = true
}

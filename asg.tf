module "asg_module" {
  source              = "./modules/asg_module"
  application_name    = var.application_name
  image_id            = var.image_id
  instance_type       = var.instance_type
  key                 = var.key
  subnets             = flatten([module.vpc.private_subnets])
  security_groups     = [data.aws_security_group.sg.id]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  container_insights  = false
}

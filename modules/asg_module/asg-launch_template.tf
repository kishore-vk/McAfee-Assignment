resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.application_name}-launch-template-"
  image_id      = var.image_id
  instance_type = var.instance_type
  ebs_optimized = true
  key_name      = var.key
  user_data     = base64encode(data.template_file.user_data.rendered)
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = "gp3"
      volume_size = 30
      encrypted   = true
      delete_on_termination = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = var.security_groups
    delete_on_termination = true
  }
}

# User data
data "template_file" "user_data" {
  template = filebase64("${path.module}/user_data.sh")
  vars = {
    app_name = var.application_name
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = var.application_name
  force_delete        = false
  vpc_zone_identifier = var.subnets
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  health_check_type   = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  termination_policies = [
    "OldestLaunchTemplate",
    "ClosestToNextInstanceHour",
    "Default"
  ]

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
}

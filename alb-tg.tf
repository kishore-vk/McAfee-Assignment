# Create external ALB
resource "aws_lb" "alb" {
  name               = "${var.application_name}-ext"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ data.aws_security_group.sg.id ]
  subnets            = flatten([module.vpc.public_subnets])
}

# Create target group
resource "aws_lb_target_group" "target_group" {
  name                  = "${var.application_name}-tg"
  port                  = 80
  protocol              = "HTTP"
  vpc_id                =  module.vpc.vpc_id
  deregistration_delay  = 60

  health_check {
    matcher             = "200"
    path                = "/health"
    interval            = 33
    timeout             = 30
    unhealthy_threshold = 2
  }
}

# ALB HTTPS listener with default rule
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "This is not a valid url/rule"
      status_code  = "503"
    }
  }
}

# ALB Rules
resource "aws_lb_listener_rule" "main_dns_rule" {
  listener_arn = aws_lb_listener.alb_http_listener.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = [
        "${var.application_name}*.com"
      ]
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      action,
      condition
    ]
  }
}

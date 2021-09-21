resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.application_name}-cluster"
  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name                    = "${var.application_name}-cluster-service"
  cluster                 = aws_ecs_cluster.ecs_cluster.arn
  task_definition         = aws_ecs_task_definition.ecs_task_def.arn
  enable_ecs_managed_tags = true
  scheduling_strategy     = "REPLICA"
  propagate_tags          = "SERVICE"
  desired_count           = 1
  #health_check_grace_period_seconds = 120
/*
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.application_name}"
    container_port   = var.application_port
  }
*/
  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }

  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }
}
resource "aws_ecs_task_definition" "ecs_task_def" {
  family = "${var.application_name}-task-def"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "nginx"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])
}
/*
# Creates an Initial Hello world task definiton for your service to validate ALB / ACM 
resource "aws_ecs_task_definition" "ecs_task_def" {
  family                = "${var.application_name}-task-def"
  container_definitions = data.template_file.task-def.rendered
  network_mode          = "bridge"
}

# Task definition template files
data "template_file" "task-def" {
  template = file("./task-definition.json")
  vars     = {
    application = var.application_name
  }
}
*/

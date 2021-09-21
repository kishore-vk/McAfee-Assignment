
# ecs role
resource "aws_iam_role" "ecs_iam_role" {
  name     = "${var.application_name}-ecs-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com", "ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ECSTaskExeECS" {
  role       = aws_iam_role.ecs_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecstask_iam_role_policy" {
  name     = "${var.application_name}-ecstask-policy"
  role     = aws_iam_role.ecs_iam_role.id
  policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:SubmitTaskStateChange",
                "ecs:UpdateContainerInstancesState",
                "ecs:DeleteCluster",
                "ecs:RegisterContainerInstance",
                "ecs:StartTask",
                "ecs:DescribeClusters",
                "ecs:RunTask",
                "ecs:ListTasks",
                "ecs:UpdateContainerAgent",
                "ecs:StopTask",
                "ecs:SubmitContainerStateChange",
                "ecs:ListContainerInstances",
                "ecs:DeregisterContainerInstance",
                "ecs:DescribeContainerInstances",
                "ecs:DescribeTasks"
            ],
            "Resource": "arn:aws:ecs:*:*:container-instance/*"
        }
    ]
}
EOF
}


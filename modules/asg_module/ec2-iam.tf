resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name     = "${var.application_name}-ec2-iam-instance-profile"
  role     = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_role" "ec2_iam_role" {
  name     = "${var.application_name}-ec2-iam-role"
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

resource "aws_iam_role_policy_attachment" "EC2ContainerServiceAutoscaleRole" {
  role       = aws_iam_role.ec2_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_iam_role_policy_attachment" "EC2ContainerServiceforEC2Role" {
  role       = aws_iam_role.ec2_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "EC2ContainerServiceRole" {
  role       = aws_iam_role.ec2_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "EC2ContainerServiceEventsRole" {
  role       = aws_iam_role.ec2_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_role_policy_attachment" "ECSTaskExeASG" {
  role       = aws_iam_role.ec2_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecr_repository" "foo" {
  name = "${var.application_name}-ecr"
}

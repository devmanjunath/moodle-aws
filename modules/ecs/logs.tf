resource "aws_cloudwatch_log_group" "example" {
  name         = "example"
  skip_destroy = false
}

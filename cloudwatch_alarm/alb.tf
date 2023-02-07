resource "aws_lb" "kasm" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-07ec6abe6212a65a5"]
  subnets            = ["subnet-020ecabb64aee1572", "subnet-0e91a4d051551fc11", "subnet-01e1fec3ee974ab1d"]
}

resource "aws_lb_target_group" "kasm" {
  name        = "kasm-alb"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-0f6cddb7b6fd80ed8"
}

# resource "aws_lb_target_group_attachment" "kasm" {
#   target_group_arn = aws_lb_target_group.kasm.arn
#   target_id        = aws_lb.kasm.arn
#   port             = 80
# }

resource "aws_lb_listener" "kasm" {
  load_balancer_arn = aws_lb.kasm.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kasm.arn
  }
}
resource "aws_security_group" "allow_redis_conn" {
  name        = "allow redis connectivity"
  description = "allow redis connectivity"
  vpc_id      = aws_vpc.default.id
  ingress {
    description = "SSH into VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
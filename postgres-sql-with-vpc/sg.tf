resource "aws_security_group" "allow_postgres_conn" {
  name        = "allow postgres connectivity"
  description = "allow postgres connectivity"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "allow db connectivity"
    from_port   = 5432
    to_port     = 5432
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
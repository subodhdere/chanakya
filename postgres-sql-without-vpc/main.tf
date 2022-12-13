provider "aws" {
  region = local.region
}

locals {
  region = "ap-south-1"
  tags = {
    "Name" = "postgres-instance1"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "postgres-instance1"
  db_name                = "mydb"
  engine                 = "postgres"
  engine_version         = "14.1"
  instance_class         = "db.t3.micro"
  username               = "admin123"
  password               = "admin123"
  skip_final_snapshot    = true
  allocated_storage      = 20
  max_allocated_storage  = 100
  port                   = 5432
  tags                   = local.tags
  multi_az               = true
  vpc_security_group_ids = [aws_security_group.allow_postgres_conn.id]
}

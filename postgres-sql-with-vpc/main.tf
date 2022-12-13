
provider "aws" {
  region = local.region
}

locals {
  name   = "postgres-instance"
  region = "ap-south-1"
  tags = {
    "Name" = "postgres-instance"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "postgres-instance"
  db_name                = "mydb"
  engine                 = "postgres"
  engine_version         = "14.1"
  instance_class         = "db.t3.micro"
  username               = "admin123"
  password               = "admin123"
  skip_final_snapshot    = false
  allocated_storage      = 20
  max_allocated_storage  = 100
  port                   = 5432
  tags                   = local.tags
  multi_az               = true
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [aws_security_group.allow_postgres_conn.id]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.99.0.0/18"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets  = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
  database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  tags = local.tags
}

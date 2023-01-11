resource "aws_elasticache_cluster" "kasm_redis" {
  cluster_id           = "sd123"
  engine               = "redis"
  node_type            = "cache.t2.micro"
#  security_group_ids   = [aws_security_group.kasm_redis.id]
  subnet_group_name    = "${aws_elasticache_subnet_group.kasm_redis.name}"
  port                 = 6379
  num_cache_nodes      = 1
  engine_version       = "5.0.0"
  parameter_group_name = "default.redis5.0"
  availability_zone    = "ap-south-1a"
}

resource "aws_elasticache_subnet_group" "kasm_redis" {
  name       = "kasm-redis"
  subnet_ids = data.aws_subnet_ids.private_ca_central_1.ids
  
}

data "aws_subnet_ids" "private_ca_central_1" {
  vpc_id = "${data.aws_vpc.kasm_vpc_ca_central_1.id}"
}

variable "vpc_id" {
  default = "vpc-06f907545a61bdb25"
}

data "aws_vpc" "kasm_vpc_ca_central_1" {
  id = var.vpc_id 
}
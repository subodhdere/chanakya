data "aws_availability_zones" "available" {}

data "aws_subnet_ids" "public" {
vpc_id = var.vpc_id
}

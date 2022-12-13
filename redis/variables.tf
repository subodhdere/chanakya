variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "namespace" {
  description = "Default namespace"
  default = "demo-redis"
}

variable "cluster_id" {
  description = "Id to assign the new cluster"
}

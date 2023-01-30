variable "vpc_id" {
  type        = string
  default     = "vpc-0f6cddb7b6fd80ed8"
}

variable "aws_subnet" {
  type = list
  default = ["subnet-020ecabb64aee1572","subnet-0e91a4d051551fc11","subnet-01e1fec3ee974ab1d"]
}
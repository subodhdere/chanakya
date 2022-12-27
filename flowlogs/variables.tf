variable "s3_bucket_name" {
  type        = string
  default     = "kasm-flow-logs"
  description = "AWS S3 target bucket name"
}

variable "aws_account1_id" {
  type        = string
  default     = "829657564189"
  description = "AWS account id"
}

variable "aws_account1_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS account1 region"
}

variable "aws_account2_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS account2 region"
}

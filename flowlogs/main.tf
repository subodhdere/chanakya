provider "aws" {
  region = var.aws_account1_region
}

provider "aws" {
  region  = var.aws_account2_region
  alias   = "second_region"
  profile = "second_account"
}


resource "aws_flow_log" "kasm" {
  log_destination      = "arn:aws:s3:::${var.s3_bucket_name}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = "vpc-0f6cddb7b6fd80ed8"
  depends_on = [
    aws_s3_bucket.kasm,
    aws_s3_bucket_policy.kasm
  ]
}

resource "aws_s3_bucket" "kasm" {
  bucket        = var.s3_bucket_name
  provider      = aws.second_region
  force_destroy = true
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "kasm" {
  bucket   = aws_s3_bucket.kasm.id
  provider = aws.second_region
  policy   = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}",
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control",
                    "aws:SourceAccount": "${var.aws_account1_id}"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:${var.aws_account1_region}:${var.aws_account1_id}:*"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": [
                "s3:GetBucketAcl",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}",
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.aws_account1_id}"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:${var.aws_account1_region}:${var.aws_account1_id}:*"
                }
            }
        }
    ]
}
POLICY
}
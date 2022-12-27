module "ecr_registry" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "registry-example"

  create_repository = false

  # Registry Policy
  create_registry_policy = true
  registry_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "testpolicy",
        Effect = "Allow",
        Principal = {
          "AWS" : "arn:aws:iam::829657564189:root"
        },
        Action = [
          "ecr:ReplicateImage"
        ],
        Resource = [
          "arn:aws:ecr:ap-south-1:829657564189:repository/*"
        ]
      }
    ]
  })

  # Registry Scanning Configuration
  manage_registry_scanning_configuration = true
  registry_scan_type                     = "ENHANCED"
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter         = "*"
      filter_type    = "WILDCARD"
      }, {
      scan_frequency = "CONTINUOUS_SCAN"
      filter         = "kasm"
      filter_type    = "WILDCARD"
    }
  ]

  # Registry Replication Configuration
  create_registry_replication_configuration = true
  registry_replication_rules = [
    {
      destinations = [{
        region      = "us-west-2"
        registry_id = "829657564189"
        }]

      repository_filters = [{
        filter      = "kasm"
        filter_type = "PREFIX_MATCH"
      }]
    }
  ]

  tags = {
    Environment = "kasm"
  }
}


resource "aws_ecr_repository" "repo" {
  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability


  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

}

resource "aws_ecr_lifecycle_policy" "this" {
  depends_on = [
    aws_ecr_repository.repo
  ]
  repository = var.repository_name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}
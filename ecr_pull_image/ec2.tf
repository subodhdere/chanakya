resource "aws_instance" "ec2" {
  ami                  = "ami-06984ea821ac0a879"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.profile.name
  key_name             = "demo-mumbai"
  user_data = <<EOF
    #! /bin/bash
    set -e
    # Make sure we have all the latest updates when we launch this instance
    apt update -y && apt upgrade -y
    # Install components
    apt install -y docker.io amazon-ecr-credential-helper
    # Add credential helper to pull from ECR
    mkdir -p ~/.docker && chmod 0700 ~/.docker
    echo '{"credsStore": "ecr-login"}' > ~/.docker/config.json
    # Start docker now and enable auto start on boot
    service docker start
    # Allow the ubuntu to run docker commands without sudo
    usermod -aG docker ubuntu
    # Run application at start
    docker image pull 829657564189.dkr.ecr.ap-south-1.amazonaws.com/kasm-repo:latest
    EOF
}
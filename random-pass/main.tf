provider "aws" {
  region = "ap-south-1"
}

resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  name = "test-db-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

resource "aws_db_instance" "default" {
  identifier        = "testdb"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  db_name              = "mydb"
  username = "dbadmin"
  skip_final_snapshot = true
  password = aws_secretsmanager_secret_version.password.secret_string
}

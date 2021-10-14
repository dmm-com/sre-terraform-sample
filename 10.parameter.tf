resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_ssm_parameter" "rds_password" {
  name   = "/sample/API_DBPASS"
  type   = "String"
  value  = random_password.master_password.result
}

resource "aws_ssm_parameter" "rds_dbname" {
  name   = "/sample/API_DBNAME"
  type   = "String"
  value  = var.database_name
}

resource "aws_ssm_parameter" "rds_user_name" {
  name   = "/sample/API_DBUSER"
  type   = "String"
  value  = var.master_username
}

resource "aws_ssm_parameter" "rds_endpoint" {
  name   = "/sample/API_DBHOST"
  type   = "String"
  value  = aws_rds_cluster.rds.endpoint
}

resource "aws_ssm_parameter" "sample_git_token" {
  name   = "/sample/GITHUB_TOKEN"
  type   = "String"
  value  = var.sample_git_token
}

resource "aws_ssm_parameter" "sample_git_user" {
  name   = "/sample/GITHUB_USERNAME"
  type   = "String"
  value  = var.sample_git_user
}
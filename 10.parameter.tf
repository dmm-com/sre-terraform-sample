resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_ssm_parameter" "rds_password" {
  name   = "/rds/API_DBPASS"
  type   = "String"
  value  = random_password.master_password.result
}

resource "aws_ssm_parameter" "rds_dbname" {
  name   = "/rds/API_DBNAME"
  type   = "String"
  value  = var.database_name
}

resource "aws_ssm_parameter" "rds_user_name" {
  name   = "/rds/API_DBUSER"
  type   = "String"
  value  = var.master_username
}

resource "aws_ssm_parameter" "rds_endpoint" {
  name   = "/rds/API_DBHOST"
  type   = "String"
  value  = aws_rds_cluster.rds.endpoint
}

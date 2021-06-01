data "aws_availability_zones" "zone" {
  all_availability_zones = false
  state                  = "available"
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier              = "rds"
  engine                          = "aurora-mysql"
  availability_zones              = ["ap-northeast-1a"] # 人によっては使えない可能性あるのでベタかきdata.aws_availability_zones.zone.names
  vpc_security_group_ids          = [aws_security_group.rds.id]
  engine_version                  = "5.7.mysql_aurora.2.03.2"
  db_subnet_group_name            = aws_db_subnet_group.rds.name
  database_name                   = "mydb"
  master_username                 = "root"
  master_password                 = "root12345" # 研修なので直接記載しているが本来パスワードは別から取得するべき
  backup_retention_period         = 5
  preferred_backup_window         = "07:00-09:00" # UTC表記
  skip_final_snapshot             = true
  apply_immediately               = true
  storage_encrypted               = true
  deletion_protection             = false
  port                            = 3306
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  lifecycle {
    ignore_changes = [master_username, master_password, deletion_protection, availability_zones]
  }
}

resource "aws_rds_cluster_instance" "write" {
  count               = 1
  identifier          = "db-write-${count.index}"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  cluster_identifier  = aws_rds_cluster.rds.id
  instance_class      = "db.r4.large"
  publicly_accessible = false
}

resource "aws_db_subnet_group" "rds" {
  name       = "db"
  subnet_ids = data.aws_subnet_ids.private.ids
}
resource "aws_db_instance" "app_db" {
  identifier                 = "cloudnative-rds-postgres"
  engine                     = "postgres"
  engine_version             = "15.4"
  instance_class             = "db.r6g.xlarge"
  allocated_storage          = 100
  multi_az                   = true
  db_subnet_group_name       = aws_db_subnet_group.db_subnets.name
  storage_encrypted          = true
  skip_final_snapshot        = false
  final_snapshot_identifier  = "prod-db-snapshot"
}

resource "aws_s3_bucket" "app_assets" {
  bucket = "cloudnative-app-assets-prod"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt" {
  bucket = aws_s3_bucket.app_assets.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

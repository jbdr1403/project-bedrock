output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "region" {
  value = "us-east-1"
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "catalog_rds_endpoint" {
  value = aws_db_instance.catalog_mysql.address
}

output "orders_rds_endpoint" {
  value = aws_db_instance.orders_postgres.address
}

output "catalog_rds_password" {
  value     = random_password.catalog_db.result
  sensitive = true
}

output "orders_rds_password" {
  value     = random_password.orders_db.result
  sensitive = true
}

output "bedrock_dev_view_access_key_id" {
  value = aws_iam_access_key.bedrock_dev_view.id
}

output "bedrock_dev_view_secret_access_key" {
  value     = aws_iam_access_key.bedrock_dev_view.secret
  sensitive = true
}
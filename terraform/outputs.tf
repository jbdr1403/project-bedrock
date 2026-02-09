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

output "bedrock_dev_view_access_key_id" {
  value = aws_iam_access_key.bedrock_dev_view.id
}

output "bedrock_dev_view_secret_access_key" {
  value     = aws_iam_access_key.bedrock_dev_view.secret
  sensitive = true
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

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
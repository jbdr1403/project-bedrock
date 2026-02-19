module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.0"
  tags = merge(local.common_tags, {
    Name = "project-bedrock-vpc"
  })

  name = "project-bedrock-vpc"
  cidr = var.vpc_cidr

  azs = var.availability_zones

  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

}

# -----------------------------
# RDS (BONUS) - Managed Databases
# -----------------------------

resource "random_password" "catalog_db" {
  length  = 20
  special = false
}

resource "random_password" "orders_db" {
  length  = 20
  special = false
}

resource "aws_db_subnet_group" "bedrock" {
  name       = "bedrock-db-subnets"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Project = "Bedrock"
  }
}

# Security Group: allow DB inbound ONLY from EKS nodes
resource "aws_security_group" "rds" {
  name        = "bedrock-rds-sg"
  description = "Allow DB traffic from EKS nodes only"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Project = "Bedrock"
  }
}

# Allow MySQL from EKS node SG
resource "aws_security_group_rule" "mysql_from_nodes" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = module.eks.node_security_group_id
  description              = "MySQL from EKS nodes"
}

# Allow Postgres from EKS node SG
resource "aws_security_group_rule" "postgres_from_nodes" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = module.eks.node_security_group_id
  description              = "Postgres from EKS nodes"
}

# Outbound allowed
resource "aws_security_group_rule" "rds_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# -----------------------------
# RDS MySQL for Catalog
# -----------------------------
resource "aws_db_instance" "catalog_mysql" {
  identifier        = "bedrock-catalog-mysql"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "catalog"
  username = "catalog"
  password = random_password.catalog_db.result

  db_subnet_group_name   = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0

  tags = {
    Project = "Bedrock"
  }
}

# -----------------------------
# RDS Postgres for Orders
# -----------------------------
resource "aws_db_instance" "orders_postgres" {
  identifier        = "bedrock-orders-postgres"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "orders"
  username = "orders"
  password = random_password.orders_db.result

  db_subnet_group_name   = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0

  tags = {
    Project = "Bedrock"
  }
}

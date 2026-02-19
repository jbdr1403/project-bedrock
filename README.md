🚀 Project Bedrock
InnovateMart – Production-Grade Amazon EKS Deployment

Cloud DevOps Capstone – Barakat 2025

📌 Overview

Project Bedrock delivers a fully automated, production-aligned Kubernetes platform for InnovateMart’s microservices-based retail application.

The environment is provisioned entirely using Terraform, deployed on Amazon EKS (v1.34+), and enhanced with observability, secure developer access, CI/CD automation, and event-driven serverless architecture.

This implementation reflects real-world DevOps best practices including infrastructure immutability, least-privilege IAM design, centralized logging, and GitOps-style deployment workflows.

🏗 Architecture Summary

AWS Region: us-east-1

EKS Cluster: project-bedrock-cluster

VPC: project-bedrock-vpc (Multi-AZ, Public + Private Subnets)

Namespace: retail-app

Ingress: AWS Load Balancer Controller (ALB)

Remote State: S3 + DynamoDB (State Locking)

Tagging: Project = barakat-2025-capstone

Data Layer

In-cluster dependencies (Core requirement)

RDS MySQL (Catalog) – Bonus

RDS PostgreSQL (Orders) – Provisioned (Bonus)

Serverless Extension

S3 Bucket: bedrock-assets-alt-soe-025-1118

Lambda Function: bedrock-asset-processor

Triggered on object upload → logs filename to CloudWatch

🔐 Security Model

IAM Developer User: bedrock-dev-view

AWS Console: ReadOnlyAccess

Kubernetes: view ClusterRole (RBAC)

Limited S3 PutObject permission (assets bucket)

No hardcoded credentials

Secrets managed via Kubernetes Secrets / Terraform

Principle of Least Privilege enforced

📊 Observability

EKS Control Plane Logging enabled (API, Audit, Scheduler, Controller Manager)

Application logs shipped to Amazon CloudWatch

Lambda execution logs available in CloudWatch Log Groups

⚙️ CI/CD Automation

GitHub Actions Pipeline:

Event Action
Pull Request terraform plan
Merge to master terraform apply

AWS credentials stored securely as repository secrets

Fully automated infrastructure lifecycle

🌍 Application Access

The Retail Store UI is exposed via AWS Application Load Balancer.

kubectl -n retail-app get ingress retail-ui -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

📦 Repository Structure
.
├── terraform/ # Infrastructure as Code
├── lambda/ # Asset processor function
├── .github/workflows # CI/CD pipeline
├── grading.json # Required Terraform outputs
└── README.md

🎯 Outcome

Project Bedrock provides:

Reproducible Infrastructure

Secure Developer Access

Production-Grade Kubernetes Deployment

Centralized Logging

Event-Driven Serverless Integration

Automated CI/CD Delivery

This environment is ready for developer hand-off and horizontal scaling.

If you'd like, I can also give you a slightly more minimalist version or a visually enhanced version with badges.

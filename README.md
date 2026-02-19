# 🚀 Project Bedrock

**InnovateMart – Production-Grade Amazon EKS Deployment**  
**Cloud DevOps Capstone – Barakat 2025**

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Amazon EKS](https://img.shields.io/badge/Amazon%20EKS-1.34+-FF9900?style=for-the-badge&logo=amazon-eks)

**Fully automated, production-ready Kubernetes platform** for a microservices-based retail application — built with real-world DevOps best practices.

## 📌 Project Highlights

- 100% **Terraform**-provisioned infrastructure
- **Amazon EKS** (v1.34+) in **us-east-1** — multi-AZ, high availability
- **GitOps**-style CI/CD via **GitHub Actions**
- Secure access: least-privilege IAM + Kubernetes RBAC
- Centralized observability with **CloudWatch**
- Event-driven serverless extension (S3 → Lambda)
- Bonus: RDS MySQL + PostgreSQL for catalog & orders

## 🏗 Architecture Overview

Multi-AZ VPC with public/private subnets → EKS cluster → AWS ALB Ingress → microservices in `retail-app` namespace.

**Core components:**

- EKS Control Plane + Managed Node Groups
- AWS Load Balancer Controller (ALB)
- RDS (MySQL & PostgreSQL) – bonus
- S3 bucket + Lambda asset processor

**Example architecture diagrams** (real-world EKS patterns for inspiration):

<grok-card data-id="040b86" data-type="image_card" data-plain-type="render_searched_image"  data-arg-size="LARGE" ></grok-card>

<grok-card data-id="7af62d" data-type="image_card" data-plain-type="render_searched_image"  data-arg-size="LARGE" ></grok-card>

<grok-card data-id="1a3022" data-type="image_card" data-plain-type="render_searched_image"  data-arg-size="LARGE" ></grok-card>

<grok-card data-id="b1c637" data-type="image_card" data-plain-type="render_searched_image"  data-arg-size="LARGE" ></grok-card>

<grok-card data-id="8562fd" data-type="image_card" data-plain-type="render_searched_image"  data-arg-size="LARGE" ></grok-card>

## 🔐 Security & Access

| Component          | Implementation                                      | Privilege Level |
| ------------------ | --------------------------------------------------- | --------------- |
| IAM Developer User | `bedrock-dev-view`                                  | ReadOnlyAccess  |
| Kubernetes RBAC    | `view` ClusterRole                                  | Read-only       |
| S3 Permissions     | PutObject only on `bedrock-assets-alt-soe-025-1118` | Least privilege |
| Secrets            | Kubernetes Secrets + Terraform                      | REDACTED        |
| Principle          | Least Privilege enforced everywhere                 | —               |

## 📊 Observability

- EKS control plane logs (**API, Audit, Scheduler, Controller Manager**) → CloudWatch
- Application logs → CloudWatch
- Lambda execution logs → CloudWatch Log Groups

Full visibility into infrastructure, application, and serverless components.

## ⚙️ CI/CD Pipeline (GitHub Actions)

| Git Event       | Action Performed  | Outcome                         |
| --------------- | ----------------- | ------------------------------- |
| Pull Request    | `terraform plan`  | Preview changes                 |
| Merge to `main` | `terraform apply` | Automatic infrastructure update |

AWS credentials stored securely as **GitHub Secrets**.

## 🌍 Application Access

Retail Store UI exposed via **AWS Application Load Balancer**:

```bash
kubectl -n retail-app get ingress retail-ui \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

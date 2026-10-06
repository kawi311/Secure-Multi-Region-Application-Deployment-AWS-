# Secure Multi-Region AWS Infrastructure

Reusable Terraform modules for a two-region AWS application stack, with regional networking, private application tiers, managed data services, monitoring, and DNS failover.

> **Portfolio project:** This repository demonstrates infrastructure-as-code patterns. Review the configuration, account limits, security controls, and estimated costs before deploying. It is not a claim of production certification or a guarantee of high availability.

## Architecture

<img width="4288" height="4604" alt="image" src="https://github.com/user-attachments/assets/c1620d53-8712-446c-bab9-40c188738a8e" />

The Terraform is organized as reusable modules plus three root stacks: `region-a`, `region-z`, and `global`. The global stack reads regional outputs from local Terraform state files to configure Route 53, so state placement and deployment order must be planned carefully.

## Capabilities

- Reusable VPC, subnet, routing, security group, ALB, WAF, and Auto Scaling modules.
- Private application subnets with NAT gateways and Systems Manager VPC endpoints.
- RDS database resources, generated database passwords, and cross-region replication-related configuration.
- S3 public-access blocking, versioning, and optional cross-region replication.
- CloudWatch alarms with SNS notifications, AWS Inspector enablement, and Route 53 health checks/failover.

## Repository layout

| Path | Purpose |
| --- | --- |
| `modules/` | Reusable Terraform modules for networking, compute, data, security, DNS, and monitoring |
| `region-a/` | Primary regional stack (`ap-southeast-1`) |
| `region-z/` | Secondary regional stack (`us-east-1`) |
| `global/` | Route 53 resources that connect the regional stacks |
| `provider.tf`, `versions.tf`, `variables.tf` | Root-level Terraform provider and version configuration |

## Prerequisites

- Terraform `>= 0.14.0` (AWS provider constraint: `~> 4.0`; see the committed lock files for selections).
- AWS CLI credentials for an account where you are authorized to create the resources.
- An AWS account, a verified notification email, and (for the global stack) a domain you control.
- Region-appropriate AMI IDs and the required cross-region KMS/RDS identifiers.

Authenticate through the AWS CLI or a named profile. Do not put access keys, passwords, private keys, account-specific state, or real personal details in source control.

## Configuration and validation

Create local variable files from the examples and replace every `REPLACE_ME` value with values appropriate to your account:

```powershell
Copy-Item region-a/terraform.tfvars.example region-a/terraform.tfvars
Copy-Item region-z/terraform.tfvars.example region-z/terraform.tfvars
Copy-Item global/terraform.tfvars.example global/terraform.tfvars
```

The real `*.tfvars` files are ignored by Git. Keep the examples sanitized.

Format and validate each root stack:

```powershell
terraform fmt -recursive
terraform -chdir=region-a init -backend=false
terraform -chdir=region-a validate
terraform -chdir=region-z init -backend=false
terraform -chdir=region-z validate
terraform -chdir=global init -backend=false
terraform -chdir=global validate
```

Before any deployment, review the dependency graph and a fresh plan for each stack. The regional stacks have cross-stack dependencies (including S3 destination and RDS/KMS references), and the global stack reads local state paths; a single `terraform apply` at the repository root is not the deployment workflow. State files and saved plans can contain secrets and must remain private.

## Cost and security notes

- NAT gateways, load balancers, RDS, WAF, CloudWatch, Inspector, and data transfer can incur ongoing AWS charges. Destroy test resources when they are no longer needed.
- The current key-pair configuration generates a TLS private key and writes a `.pem` file; Terraform state can also contain that private key. Do not publish state or generated keys. For real deployments, prefer an externally managed key pair and protected remote state.
- The demo bootstrap script disables `firewalld`; the S3 module enables `force_destroy`, and the secondary RDS configuration skips its final snapshot. Review these behaviors before deploying or destroying resources.
- Review ingress rules, IAM permissions, encryption, backup retention, and failover behavior for your own threat model before deployment.
- The global stack currently uses local Terraform state references. For team or long-lived use, move to encrypted, access-controlled remote state with locking and update those references.

## License

No license is included yet. Add a license only after choosing the terms under which you want others to use this project.

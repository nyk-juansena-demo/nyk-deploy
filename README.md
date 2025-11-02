# NYK Infra Demo (Weekend-Ready)

A minimal, credible demo showing AWS IaC, CI/CD patterns, and Kubernetes GitOps without high AWS costs.

## What This Demonstrates
- Terraform modules and remote state (S3 + DynamoDB lock)
- ECR repo + CI role (cheap resources)
- GitHub Actions workflows (plan/apply flow and ECR build/push)
- Kubernetes manifests with Kustomize and a Helm chart (for discussion)
- Optional: ArgoCD GitOps to local Rancher Desktop cluster

## Prereqs (WSL)
- Terraform 1.5+
- AWS CLI configured (`aws sts get-caller-identity` works)
- kubectl (for local K8s demo)
- Rancher Desktop (or similar local K8s)
- (Optional) ArgoCD install script uses internet access

## Quickstart
```bash
git clone <your-fork-url> nyk-infra-demo && cd nyk-infra-demo

# Bootstrap Terraform remote state (creates S3+DynDB)
./scripts/bootstrap_backend.sh us-east-1

# Initialize and apply dev env (creates ECR + CI role)
cd infra/environments/dev
terraform init
terraform apply -auto-approve
```

**Outputs**: ECR repo URL and CI role name.

## GitHub Actions (talk-through)
- `.github/workflows/terraform-plan.yml` validates & plans infra in PRs.
- `.github/workflows/app-build-push.yml` builds & pushes Docker image to ECR (configure repo variables: AWS_REGION, AWS_IAM_ROLE_ARN, ECR_REPO).

## Local Kubernetes GitOps (Optional)
```bash
# Install ArgoCD into your local cluster
./scripts/install_argocd.sh

# Apply app with Kustomize (dev)
kubectl apply -k k8s/overlays/dev

# OR deploy via Helm
helm install nyk-demo ./helm/app
```

Port-forward to view:
```bash
kubectl port-forward svc/nyk-demo-dev 8080:80
```

## Clean Up
```bash
# Destroy dev resources
cd infra/environments/dev && terraform destroy -auto-approve

# Destroy backend
cd ../../modules/s3_backend && terraform destroy -auto-approve
```

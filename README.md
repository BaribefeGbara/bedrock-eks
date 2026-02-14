# Project Bedrock - AWS EKS Deployment

Production-grade Kubernetes infrastructure on AWS EKS with automated CI/CD pipeline.

## Overview

This project provisions a complete Amazon EKS cluster with networking, security, observability, and serverless components using Infrastructure as Code.

## Architecture

- VPC with public and private subnets across two availability zones
- EKS cluster running Kubernetes 1.29
- Retail Store microservices application (5 services)
- S3-triggered Lambda function for asset processing
- CloudWatch logging for cluster and applications
- GitHub Actions CI/CD pipeline

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0
- kubectl
- Helm 3

## Quick Start

### 1. Clone the repository
```
git clone https://github.com/BaribefeGbara/bedrock-eks.git
cd bedrock-eks
```

### 2. Deploy infrastructure
```
cd terraform
terraform init
terraform plan
terraform apply
```

This will create all AWS resources. Deployment takes approximately 15-20 minutes.

### 3. Configure kubectl access
```
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
kubectl get nodes
```

### 4. Deploy the application
```
cd ~/retail-store-sample-app/src/app/chart
helm dependency build
helm install retail-store . --namespace retail-store --create-namespace
```

Wait 5-10 minutes for all pods to start.

### 5. Access the application
```
kubectl get svc ui -n retail-store
```

Use the EXTERNAL-IP address to access the retail store in your browser.

## Infrastructure Components

### Networking
- VPC CIDR: 10.0.0.0/16
- Public Subnets: 10.0.101.0/24, 10.0.102.0/24
- Private Subnets: 10.0.1.0/24, 10.0.2.0/24
- Single NAT Gateway for cost optimization

### Compute
- EKS Cluster Version: 1.29
- Node Group: 2 t3.small instances
- Auto-scaling: min 2, max 4, desired 2

### Storage & Serverless
- S3 Bucket: bedrock-assets-altsoe0250985
- Lambda Function: bedrock-asset-processor
- Trigger: S3 ObjectCreated events

### Security
- IAM user with read-only console and CLI access
- Kubernetes RBAC with view-only permissions
- Security groups restricting traffic between components

### Observability
- CloudWatch Logs for EKS control plane
- CloudWatch Logs for application containers
- Lambda execution logs

## Testing

### Test Lambda trigger
```
echo "test file" > test.jpg
aws s3 cp test.jpg s3://bedrock-assets-altsoe0250985/
aws logs tail /aws/lambda/bedrock-asset-processor --since 5m
```

### Test RBAC permissions
```
export AWS_ACCESS_KEY_ID="<developer-key>"
export AWS_SECRET_ACCESS_KEY="<developer-secret>"
kubectl get pods -n retail-store
kubectl delete pod <pod-name> -n retail-store
```

The get command should succeed. The delete command should be denied.

## CI/CD Pipeline

GitHub Actions workflow automatically:
- Runs terraform plan on pull requests
- Runs terraform apply on merge to main
- Generates grading.json output file

Workflow file: .github/workflows/terraform.yml

## Cleanup

To destroy all infrastructure:
```
cd terraform
terraform destroy
```

Type yes when prompted. This will delete all AWS resources created by this project.

## Cost Estimation

Daily operational cost: approximately $5-6 USD

- EKS Control Plane: $2.40/day
- EC2 Instances: $1.66/day
- NAT Gateway: $1.08/day
- Other services: <$1.00/day

## Troubleshooting

### Pods not starting

Check pod status:
```
kubectl get pods -n retail-store
kubectl describe pod <pod-name> -n retail-store
```

Common issues:
- Insufficient node memory (reduce pod resource requests)
- Image pull errors (check internet connectivity through NAT)

### Cannot connect to cluster

Update kubeconfig:
```
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
```

Verify AWS credentials:
```
aws sts get-caller-identity
```

### Terraform state lock errors

Force unlock if necessary:
```
terraform force-unlock <lock-id>
```

## Project Structure
```
.
├── terraform/              # Infrastructure as Code
│   ├── main.tf            # VPC and EKS configuration
│   ├── s3-lambda.tf       # Serverless components
│   ├── iam-developer.tf   # IAM user configuration
│   ├── outputs.tf         # Terraform outputs
│   └── variables.tf       # Input variables
├── lambda/                # Lambda function code
│   └── index.py
├── .github/workflows/     # CI/CD pipeline
│   └── terraform.yml
└── README.md
```

## License

This project is for educational purposes.

## Contact

For questions or issues, please open an issue in the GitHub repository.

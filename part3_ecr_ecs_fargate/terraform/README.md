# Part 3 — Deploy Docker apps to ECR → ECS Fargate → ALB (ap-south-1)

## Prereqs
- AWS CLI configured (ap-south-1)
- Docker installed and running
- Terraform >= 1.3
- (Optional) S3 + DynamoDB if you want remote state — backend.tf is currently disabled

## Steps summary

### 1) Initialize Terraform
```powershell
cd part3_ecr_ecs_fargate\terraform
terraform init

 aws AccId->811264947819
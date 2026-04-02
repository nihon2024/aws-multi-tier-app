AWS Multi-Tier Architecture (Terraform)

Production-style AWS infrastructure deployed using Terraform.

⸻

🚀 Overview

This project provisions a scalable, secure multi-tier architecture on AWS:
	•	Internet-facing Application Load Balancer (ALB)
	•	EC2 Auto Scaling Group for web/app layer
	•	RDS (MySQL) in private subnets
	•	S3 bucket for storage/logs
	•	Route53 + ACM for DNS and HTTPS (optional)

⸻

🏗️ Architecture
Flow
	1.	Clients → ALB (HTTP/HTTPS)
	2.	ALB → EC2 instances (Auto Scaling)
	3.	EC2 → RDS (private subnet only)
	4.	Optional:
	•	ALB → S3 (access logs)
	•	App → S3 (assets/backups)

⸻

🔐 Security Model
Layer                           Access
ALB                             Public (80/443)
EC2                             Only from ALB
RDS                             Only from EC2

	•	No direct internet access to EC2 or RDS
	•	SSH removed (recommended to use AWS SSM)

⸻

📁 Project Structure

aws-multi-tier-app/
├── infra/                 # All Terraform code
│   ├── provider.tf
│   ├── networking.tf
│   ├── compute.tf
│   ├── database.tf
│   ├── security.tf
│   ├── storage.tf
│   ├── dns.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── README.md
└── architecture-diagram.png

How to Run
cd infra
terraform init
terraform plan
terraform apply

Notes
	•	Default region: us-east-1
	•	Database password must be provided during execution
	•	Infrastructure follows best practices for isolation and scalability

⸻

🧠 Future Improvements
	•	Remote backend (S3 + DynamoDB)
	•	Terraform modules
	•	CI/CD pipeline (GitHub Actions)
:::

Author

Nitesh Kumar
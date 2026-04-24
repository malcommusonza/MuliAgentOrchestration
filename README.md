# OpenClaw Native Multi-Agent Dev Team

> Zero-cost, fully automated AI development team on AWS—deployed with a single command.

## Key Features
- **Zero Cost** – Uses only free models via OpenRouter
- **Fully Automated** – No manual onboarding or configuration required
- **Native Multi-Agent** – OpenClaw's built-in agent orchestration
- **Infrastructure as Code** – Modular Terraform with Terraform Cloud backend
- **Specialized Agents** – Orchestrator, Developer, QA, Planner, and Writer

## Quick Start
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your OpenRouter API key
terraform init
terraform apply

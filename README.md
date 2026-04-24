# OpenClaw Native Multi-Agent Orchestration

This Terraform project deploys OpenClaw on AWS with native multi-agent orchestration features. It creates a fully automated infrastructure that sets up multiple specialized AI agents for development tasks.

## Features

- **Multi-Agent System**: Pre-configured with 5 specialized agents:
  - Orchestrator: Task coordination and delegation
  - Developer: Code implementation
  - QA Reviewer: Testing and code review
  - Planner: Strategic analysis and planning
  - Technical Writer: Documentation creation

- **Automated Deployment**: User data script installs Docker, configures OpenClaw with agents, and starts the gateway
- **AWS Infrastructure**: VPC, subnets, security groups, IAM roles, and EC2 instance
- **OpenRouter Integration**: Uses free-tier OpenRouter API for AI models
- **Terraform Cloud**: State management via Terraform Cloud

## Prerequisites

- Terraform >= 1.5
- AWS account with appropriate permissions
- Terraform Cloud account and organization
- OpenRouter API key (free at https://openrouter.ai/keys)

## Quick Start

1. Clone this repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Edit `terraform.tfvars` with your values:
   - `tfc_organization`: Your Terraform Cloud org
   - `tfc_workspace`: Your Terraform Cloud workspace
   - `openrouter_api_key`: Your OpenRouter API key
4. Run `terraform init`
5. Run `terraform plan`
6. Run `terraform apply`

## Outputs

After deployment, note these outputs:
- `openclaw_gateway_url`: URL to access the OpenClaw gateway
- `instance_public_ip`: Public IP of the EC2 instance
- `ssh_command`: Command to SSH into the instance

## Security Notes

- Restrict `allowed_cidrs` and `ssh_allowed_cidrs` to your IP ranges
- The OpenRouter API key is stored securely as a sensitive variable
- SSH access is enabled for troubleshooting

## Architecture

The deployment creates:
- VPC with public/private subnets
- EC2 instance running Amazon Linux 2023
- Docker container with OpenClaw and pre-configured agents
- Security groups allowing gateway and SSH access
- IAM role with SSM and optional Bedrock access

## Customization

- Modify agent configurations in `modules/openclaw/templates/user_data.sh.tpl`
- Adjust instance type, models, or other variables in `terraform.tfvars`
- Add more agents by extending the `agents.list` in the user data script
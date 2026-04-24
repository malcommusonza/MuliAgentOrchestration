# -----------------------------------------------------------------------------
# TERRAFORM CLOUD
# -----------------------------------------------------------------------------
variable "tfc_organization" {
  description = "Terraform Cloud organization name"
  type        = string
}

variable "tfc_workspace" {
  description = "Terraform Cloud workspace name"
  type        = string
}

# -----------------------------------------------------------------------------
# AWS
# -----------------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
  description = "Create NAT Gateway"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "gateway_port" {
  description = "OpenClaw gateway port"
  type        = number
  default     = 18789
}

# -----------------------------------------------------------------------------
# SECURITY
# -----------------------------------------------------------------------------
variable "allowed_cidrs" {
  description = "CIDRs allowed to access OpenClaw"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_bedrock_access" {
  description = "Grant Bedrock access"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# OPENROUTER & OPENCLAW
# -----------------------------------------------------------------------------
variable "openrouter_api_key" {
  description = "OpenRouter API key (free tier)"
  type        = string
  sensitive   = true
}

variable "default_model" {
  description = "Default model for OpenClaw"
  type        = string
  default     = "openrouter/auto"
}

variable "openclaw_image" {
  description = "OpenClaw Docker image"
  type        = string
  default     = "ghcr.io/phioranex/openclaw-docker:latest"
}

# -----------------------------------------------------------------------------
# TAGS
# -----------------------------------------------------------------------------
variable "global_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    Project   = "OpenClaw-Native-MultiAgent"
    ManagedBy = "Terraform"
  }
}

# -----------------------------------------------------------------------------
# TAGS
# -----------------------------------------------------------------------------
variable "global_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    Project   = "OpenClaw-Native-MultiAgent"
    ManagedBy = "Terraform"
  }
}
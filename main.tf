terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "MalcomTMusonza"
    hostname     = "app.terraform.io"

    workspaces {
      name = "MultiAgentOrchestrationV2"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.global_tags
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

module "network" {
  source = "./modules/network"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  enable_nat_gateway  = var.enable_nat_gateway
  tags                = var.global_tags
}

module "security" {
  source = "./modules/security"

  environment           = var.environment
  vpc_id                = module.network.vpc_id
  gateway_port          = var.gateway_port
  allowed_cidrs         = var.allowed_cidrs
  ssh_allowed_cidrs     = var.ssh_allowed_cidrs
  enable_bedrock_access = var.enable_bedrock_access
  tags                  = var.global_tags
}

module "openclaw" {
  source = "./modules/openclaw"

  environment           = var.environment
  ami_id                = data.aws_ami.amazon_linux_2023.id
  instance_type         = var.instance_type
  subnet_id             = module.network.public_subnet_ids[0]
  security_group_id     = module.security.instance_security_group_id
  instance_profile_name = module.security.instance_profile_name
  key_pair_name          = var.key_pair_name
  gateway_port          = var.gateway_port
  openrouter_api_key    = var.openrouter_api_key
  default_model         = var.default_model
  openclaw_image        = var.openclaw_image
  tags                  = var.global_tags
}
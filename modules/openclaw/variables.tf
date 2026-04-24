variable "environment" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "gateway_port" {
  type    = number
  default = 18789
}

variable "root_volume_size" {
  type    = number
  default = 30
}

variable "openclaw_image" {
  type    = string
  default = "ghcr.io/phioranex/openclaw-docker:latest"
}

variable "openrouter_api_key" {
  type      = string
  sensitive = true
}

variable "default_model" {
  type    = string
  default = "openrouter/auto"
}

variable "tags" {
  type    = map(string)
  default = {}
}
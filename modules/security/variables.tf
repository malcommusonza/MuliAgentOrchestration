variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "gateway_port" {
  type    = number
  default = 18789
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "enable_bedrock_access" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
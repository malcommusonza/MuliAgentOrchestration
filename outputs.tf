output "openclaw_gateway_url" {
  description = "OpenClaw gateway URL"
  value       = module.openclaw.gateway_url
}

output "instance_public_ip" {
  description = "EC2 instance public IP"
  value       = module.openclaw.public_ip
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i <your-key> ec2-user@${module.openclaw.public_ip}"
}
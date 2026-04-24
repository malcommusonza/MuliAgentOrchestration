output "instance_id" {
  value = aws_instance.openclaw.id
}

output "public_ip" {
  value = aws_instance.openclaw.public_ip
}

output "gateway_url" {
  value = "http://${aws_instance.openclaw.public_ip}:${var.gateway_port}"
}
data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/user_data.sh.tpl", {
      gateway_port = var.gateway_port
    })
  }
}

resource "aws_instance" "openclaw" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.instance_profile_name
  key_name               = var.key_pair_name != "" ? var.key_pair_name : null

  user_data = data.cloudinit_config.user_data.rendered

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-openclaw"
  })
}
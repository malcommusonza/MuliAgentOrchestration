resource "aws_security_group" "instance" {
  name        = "${var.environment}-openclaw-instance-sg"
  description = "Security group for OpenClaw EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.gateway_port
    to_port     = var.gateway_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
    description = "OpenClaw Gateway API"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-openclaw-instance-sg"
  })
}

resource "aws_iam_role" "instance" {
  name = "${var.environment}-openclaw-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "bedrock" {
  count      = var.enable_bedrock_access ? 1 : 0
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.environment}-openclaw-instance-profile"
  role = aws_iam_role.instance.name
}
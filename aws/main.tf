resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "${path.module}/${var.instance_name}-key.pem"
}

resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = templatefile("${path.module}/user_data.sh", {
    repo_url    = var.repo_url
    repo_branch = var.repo_branch
  })

  tags = {
    Name = var.instance_name
  }
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "private_key" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}

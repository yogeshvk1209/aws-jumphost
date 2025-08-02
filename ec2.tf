resource "aws_security_group" "jp_ec2_sg" {
  name        = "jp_ec2_security_group"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    description = "SSH access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jp_ec2_sg"
  }
}

data "aws_vpc" "default" {
  default = true
}

# Get default subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  # Filter by availability zone if specified
  dynamic "filter" {
    for_each = var.availability_zone != null ? [1] : []
    content {
      name   = "availability-zone"
      values = [var.availability_zone]
    }
  }
}

data "aws_ami" "lt_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "jp_host" {
  ami                    = data.aws_ami.lt_ami.id
  #instance_market_options {
  #  market_type          = "spot"
  #  spot_options {
  #    max_price          = 0.0031
  #  }
  #}
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.jp_ec2_sg.id]
  user_data              = file(var.userdata_script)
  key_name               = "terrakeytmp"
  tags = {
    Name = "jp_host"
  }
}

output "instance_id" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jp_host.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jp_host.public_ip
}

########################## locals ####################################
locals {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVirtegLIP9z9FR4fMNbh66iMhB5xMQ3D+jOI9YtEixgFxsTHbtQEqD9HkQ8O7MF4VkEj+WxEuh61UWIS8hWB2G9NhjPxLVnwIWRiTz/G+VYBhIgd5BP5bK+ZhgNsjIk4iktiV6bVbpOHC2QgqjM+Y8keIisN3G1D4g+lvrraOxpEE0oZJTFK2NwLelwv9O/UN+kFxsKt5XdX6j21UsczRmLuQD4YnnpignMZa51Qjdwqgq1p5eW/hF063R0DG0J6AxGz6KtzR5+rVopGuYJpliz64XQPSnjp2zKyoGdSnJ06I8E4Pw4CQpadfVGaB2Vi/xpIaGXQFlyJLDhFN30+C3N5o8OhHpDRq1rAWnTKbrPK1GadF/eJq1508QzSNyQ4SxYrGqm3KJxq4xZUng/lcPdaACMDBU7hppTDbBA/z6rCBRjXKGlVT+/jvlVWWooYsvE8D46Rv+yaH9Gq2C26r9cjSeQGSHooaGJAagxwPEwbuXqE6NTvV9A5t56wTOu9hUrtkFfdcz5lhzVQTQgvVr2HVBsaY/VQ9IV1XfxPErsTfc67tizJXqGSU18rYjrxkifSuWyLAl4lNOhvlctAbxoSGRv0HV0MHM4UTHD+UXGjFZ8fq1QAMtO1nteCL40F+I/aHtmqOcjPnMD/Sdff1V1ZS7tuE3PrdInvzCNn5YQ== jules@devbox"
}
########################## locals ####################################
########################## key_pair ##################################
resource "aws_key_pair" "terrakeytmp" {
  key_name   = "terrakeytmp"
  public_key = local.public_key
  tags = {
    Name = "terrakeytmp"
  }
}
########################## key_pair ##################################
########################## private_key ###############################
resource "local_file" "private_key_pem" {
  content         = <<-EOT
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
EOT
  filename        = "terrakeytmp.pem"
  file_permission = "0400"
}
########################## private_key ###############################

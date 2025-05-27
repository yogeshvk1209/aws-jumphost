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
  instance_market_options {
    market_type          = "spot"
    spot_options {
      max_price          = 0.0031
    }
  }
  instance_type          = "t4g.nano"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.jp_ec2_sg.id]
  user_data              = file("userdata.sh")
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

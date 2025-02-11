terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2" 
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "AkVPC"
  }
}

# Create Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "AkSubnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "AkInternetGateway"
  }
}

# Create Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "AkPubRouteTable"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["106.219.178.100/32"]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServerSG"
  }
}

# Create EC2 Instance
resource "aws_instance" "web_server" {
  ami             = "ami-0005ee01bca55ab66" # Amazon Linux 2 AMI (update as needed)
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id] 

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to ak AWS Web Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "AkWebServer"
  }
}

# Output the Public IP of the EC2 Instance
output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

resource "aws_instance" "web" {
  count                       = var.instance_count
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index)
  key_name                    = var.key_name
  # user_data                   = filebase64("${path.module}/user-data.sh")
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true


  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }

provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras enable php8.0",
      "sudo yum install -y httpd php php-mysqlnd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo mkdir -p /var/www/html",
      "sudo chown -R ec2-user:ec2-user /var/www/html"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/akashkumars/Downloads/ak-pair.pem") 
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "${path.module}/mysql-connection.php"              
    destination = "/var/www/html/mysql-connection.php"

    connection {
      type        = "ssh"
      user        = "ec2-user"               
      private_key = file("/Users/akashkumars/Downloads/ak-pair.pem") 
      host        = self.public_ip
    }
  }

   provisioner "remote-exec" {
  inline = [
    "echo 'SetEnv DB_HOST \"${var.db_endpoint}\"' | sudo tee -a /etc/httpd/conf/httpd.conf",
    "echo 'SetEnv DB_USER \"${var.db_username}\"' | sudo tee -a /etc/httpd/conf/httpd.conf",
    "echo 'SetEnv DB_PASS \"${var.db_password}\"' | sudo tee -a /etc/httpd/conf/httpd.conf",
    "echo 'SetEnv DB_NAME \"${var.db_name}\"' | sudo tee -a /etc/httpd/conf/httpd.conf",
    
    "source /etc/environment",
    "sudo chown -R apache:apache /var/www/html/",
    "sudo chmod -R 755 /var/www/html/",
    "sudo systemctl restart httpd"
  ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/akashkumars/Downloads/ak-pair.pem") 
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "web_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for Auto Scaling Group instances"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

# Define HTTP ingress rule (Port 80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_sg.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# Define SSH ingress rule (Restricted access)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web_sg.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = var.ssh_allowed_ip
}

# Define egress rule (Allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.web_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

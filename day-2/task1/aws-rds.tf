# Create a Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  # Allow MySQL access from EC2 instances
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.asg_sg.id]  # Only EC2 instances can access
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-rds-sg"
  }
}

# Create RDS Subnet Group (uses private subnets)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.vpc_name}-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.vpc_name}-rds-subnet-group"
  }
}

# Create RDS MySQL Instance
resource "aws_db_instance" "rds" {
  identifier           = "${var.vpc_name}-rds"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = var.rds_instance_type
  allocated_storage   = 20
  storage_type        = "gp2"
  username           = var.db_username
  password           = var.db_password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true

  tags = {
    Name = "${var.vpc_name}-rds"
  }
}
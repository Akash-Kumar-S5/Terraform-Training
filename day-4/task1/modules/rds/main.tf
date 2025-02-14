# Create a Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.vpc_name}-rds-sg"
  description = "Security group for RDS MySQL instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.vpc_name}-rds-sg"
  }
}

# Allow MySQL access from EC2 instances in ASG
resource "aws_vpc_security_group_ingress_rule" "rds_mysql" {
  security_group_id = aws_security_group.rds_sg.id

  from_port          = 3306
  to_port            = 3306
  ip_protocol        = "tcp"
  referenced_security_group_id = var.ec2_sg_id
}

# Allow outbound traffic from RDS
resource "aws_vpc_security_group_egress_rule" "rds_all_outbound" {
  security_group_id = aws_security_group.rds_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# Create RDS Subnet Group (uses private subnets)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.vpc_name}-rds-subnet-group"
  subnet_ids =  var.subnet_ids 

  tags = {
    Name = "${var.vpc_name}-rds-subnet-group"
  }
}

# Create RDS MySQL Instance
resource "aws_db_instance" "rds" {
  identifier             = "${var.vpc_name}-rds"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = var.rds_instance_type
  allocated_storage     = 20
  storage_type          = "gp2"
  db_name = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name  = "default.mysql8.0"
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot   = true

  tags = {
    Name = "${var.vpc_name}-rds"
  }
}
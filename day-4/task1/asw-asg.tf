# Create a Security Group for EC2 instances
resource "aws_security_group" "asg_sg" {
  name        = "${var.vpc_name}-asg-sg"
  description = "Security group for Auto Scaling Group instances"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-asg-sg"
  }
}

# Define HTTP ingress rule (Port 80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.asg_sg.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# Define SSH ingress rule (Restricted access)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.asg_sg.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = var.ssh_allowed_ip 
}

# Define egress rule (Allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.asg_sg.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# Create a Launch Template for EC2 instances
resource "aws_launch_template" "asg_template" {
  name          = "${var.vpc_name}-launch-template"
  image_id      = var.ami_id
  key_name      = var.key_name
  instance_type = var.instance_type

  # Attach Security Group
  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  # Attach the user data script
  user_data = filebase64("${path.module}/user-data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}-instance"
    }
  }
}

# Create an Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]

  desired_capacity     = var.asg_desired_capacity
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-asg-instance"
    propagate_at_launch = true
  }
}
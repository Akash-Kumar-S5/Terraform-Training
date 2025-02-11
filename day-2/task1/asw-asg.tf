# Create a Security Group for EC2 instances
resource "aws_security_group" "asg_sg" {
  vpc_id = aws_vpc.main.id

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic (optional, restrict as needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.194.142.66/32"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-asg-sg"
  }
}

# Create a Launch Template for EC2 instances
resource "aws_launch_template" "asg_template" {
  name          = "${var.vpc_name}-launch-template"
  image_id      = var.ami_id
  key_name        = var.key_name
  instance_type = var.instance_type

  # Attach Security Group
  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  # Attach the user data script
  user_data = base64encode(file("${path.module}/user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}-instance"
    }
  }
}

# Create an Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = aws_subnet.public[*].id

  desired_capacity = var.asg_desired_capacity
  min_size        = var.asg_min_size
  max_size        = var.asg_max_size

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
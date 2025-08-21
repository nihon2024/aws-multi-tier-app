# 1️⃣ Launch Template for EC2 instances
resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = "ami-00ca32bbc84273381"   # Amazon Linux 2023
  instance_type = "t2.micro"
  key_name      = "aws-eb"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Welcome to ${var.project_name} Web Server</h1>" > /var/www/html/index.html
              EOF
            )
}
# 2️⃣ Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  health_check_type    = "EC2"

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web"
    propagate_at_launch = true
  }
}

# 3️⃣ Scaling Policy (CPU > 70% → scale out)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

# 4️⃣ Scaling Policy (CPU < 30% → scale in)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}
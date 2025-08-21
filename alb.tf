# Application Load Balancer (ALB)
# 1️⃣ ALB
resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-alb"
  internal           = false                  # internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = "Dev"
  }
}

# 2️⃣ Target Group (for web servers)
resource "aws_lb_target_group" "web_tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"    # check home page
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name        = "${var.project_name}-tg"
    Environment = "Dev"
  }
}

# 3️⃣ Listener (to accept HTTP traffic on port 80)
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

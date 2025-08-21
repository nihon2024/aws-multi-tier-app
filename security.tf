# security.tf

# Web/App Security Group (public subnet)
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP, HTTPS and SSH"
  vpc_id      = aws_vpc.main.id

  # Allow inbound HTTP (80) and HTTPS (443) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from your IP only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.25/32"]  # Replace with your IP
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "web-sg"
    Environment = "Dev"
  }
}

# DB Security Group (private subnet)
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow MySQL/Postgres access from web servers only"
  vpc_id      = aws_vpc.main.id

  # Allow inbound MySQL (3306) or Postgres (5432) from web_sg
  ingress {
    from_port       = 3306       # Change to 5432 if using Postgres
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "db-sg"
    Environment = "Dev"
  }
}

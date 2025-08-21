# 1️⃣ Security Group for RDS (DB tier)
resource "aws_security_group" "db_sg1" {
  name        = "db-sg"
  description = "Allow MySQL/Postgres from web servers only"
  vpc_id      = aws_vpc.main.id

  # Allow MySQL (3306) from web/app SG
  ingress {
    from_port       = 3306
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

# 2️⃣ DB Subnet Group (private subnets)
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name        = "db-subnet-group"
    Environment = "Dev"
  }
}

# 3️⃣ KMS key for encryption (optional but recommended)
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "rds-kms-key"
    Environment = "Dev"
  }
}

# 4️⃣ RDS instance (MySQL/Postgres, Multi-AZ)
resource "aws_db_instance" "mydb" {
  identifier             = "multi-tier-db"
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = "myappdb"
  username               = var.db_username
  password               = var.db_password
  multi_az               = true
  publicly_accessible    = false
  storage_type           = "gp2"
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds.arn
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  # Backups
  backup_retention_period = 7
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = false  # safer for production

  tags = {
    Name        = "multi-tier-db"
    Environment = "Dev"
  }
}

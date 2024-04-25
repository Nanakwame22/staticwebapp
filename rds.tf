resource "aws_db_instance" "db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.micro"
  db_name              = "mydatabase"
  username             = "dbuser"
  password             = "securepassword"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  multi_az             = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "mydb-subnet-group"
  description = "DB Subnet Group for RDS instances"
  subnet_ids  = aws_subnet.public.*.id  # Replace with private subnet IDs if available

  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_security_group" "db_sg" {
  name   = "db-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306  # Adjust the port based on your DB engine
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Ideally, this should be more restricted
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security Group"
  }
}

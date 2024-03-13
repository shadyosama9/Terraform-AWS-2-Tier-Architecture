
resource "aws_db_subnet_group" "DB-Subnet" {
  name       = var.DB_SUB_NAME
  subnet_ids = [var.PRIV-SUB-1-ID, var.PRIV-SUB-2-ID] 
}

resource "aws_db_instance" "DB" {
  identifier              = "bookdb-instance"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  username                = var.DB-USER
  password                = var.DB-PASS
  db_name                 = var.DB-NAME
  multi_az                = true
  storage_type            = "gp2"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  vpc_security_group_ids = [var.DB_SG_ID] # Replace with your desired security group ID

  db_subnet_group_name = aws_db_subnet_group.DB-Subnet.name

  tags = {
    Name = "bookdb"
  }
}

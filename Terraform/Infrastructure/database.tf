resource "aws_security_group" "sg-db-instance" {
  description = var.db_description
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  ingress {
    description = var.db_ingress_ssh_description
    from_port   = var.db_ingress_ssh_port
    to_port     = var.db_ingress_ssh_port
    protocol    = var.db_ingress_ssh_protocol
    cidr_blocks = var.db_ingress_ssh_cird
  }
  
  ingress {
    description = var.db_ingress_app_description
    from_port   = var.db_ingress_app_port
    to_port     = var.db_ingress_app_port
    protocol    = var.db_ingress_app_protocol
    cidr_blocks = var.db_ingress_app_cird
  }

  egress {
    description = "Outbound rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    "responsible" = var.tag_responsible
  }
}

##EC2 database
resource "aws_instance" "db" {
  ami = var.ami_id
  subnet_id = "subnet-092430b94a12ef07e"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg-db-instance.id}"]

  tags = {
    Name = "estudiantes_automatizacion_2021_4_db"
    responsible = "estudiantes_automatizacion_2021_4"
  }
}
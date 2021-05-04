resource "aws_security_group" "sg-db-instance" {
  name = "estudiantes_automatizacion_2021_4_db"
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
    description = var.db_ingress_description
    from_port   = var.db_ingress_port
    to_port     = var.db_ingress_port
    protocol    = var.db_ingress_protocol
    cidr_blocks = var.db_ingress_cird
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
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.sg-db-instance.id}"]
  private_ip = "10.0.2.10"
  user_data = base64encode(templatefile("./database.sh", {user = "user"}))


  tags = {
    "responsible" = "estudiantes_automatizacion_2021_4_db"
    Name = "estudiantes_automatizacion_2021_4_db"

  }
}
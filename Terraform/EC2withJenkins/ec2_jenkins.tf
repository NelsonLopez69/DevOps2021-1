
resource "aws_instance" "G4_DevOps_jenkins" {
  ami           = var.ami_id
  instance_type      = var.instance_type
  # Security group assign to instance
  vpc_security_group_ids = [aws_security_group.allow_ssh_jenkins.id]
  subnet_id = var.subnet_id

  # key name
  key_name = var.key_name

  user_data = base64encode(templatefile("./jenkins.sh",{}))


  tags = {
    Name = "JenkinsEC2_G4",
    responsible = var.key_name
  }
  
}

resource "aws_eip" "eip-jenkins" {
  instance = aws_instance.G4_DevOps_jenkins.id
  vpc      = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id      = var.vpc_id

  tags = {
    Name = "estudiantes_automatizacion_2021_4"
  }
}

resource "aws_route_table" "rt-public" {
  vpc_id      = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}


resource "aws_route_table_association" "public-subnet-a-rt" {
  subnet_id     = var.subnet_id
  route_table_id = aws_route_table.rt-public.id
}

#######################################
## Resource to create security group ##
#######################################

##Preguntas: 
#Si yo no le puedo asignar una ip privada a las instancias del 
##launch template, como hago para que el lb apunte a ellas?
##Tengo que usar dos eip, una para el load balancer y otra para el nat gateway?



##Network

resource "aws_internet_gateway" "igw" {
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  tags = {
    Name = "estudiantes_automatizacion_2021_4"
  }
}

resource "aws_eip" "eip-lb" {
  instance = aws_instance.lb-front.id
  vpc      = true
}

resource "aws_eip" "eip-ngw" {
  vpc  = true
}


resource "aws_route_table" "rt-public" {
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "public-subnet-a-rt" {
  subnet_id     = data.aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "public-subnet-b-rt" {
  subnet_id     = data.aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.rt-public.id
}


resource "aws_route_table" "rt-private" {
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}


resource "aws_route_table_association" "private-subnet-a-rt" {
  subnet_id     = data.aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_route_table_association" "private-subnet-b-rt" {
  subnet_id     = data.aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.rt-private.id
}


resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip-ngw.id
  subnet_id     = data.aws_subnet.private-subnet-a.id
}


###Frontend##################

resource "aws_security_group" "sg-front-instance" {
  name = "estudiantes_automatizacion_2021_4_front_sg"
  description = var.front_sg_description
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  ingress {
    description = var.front_sg_ingress_ssh_description
    from_port   = var.front_sg_ingress_ssh_port
    to_port     = var.front_sg_ingress_ssh_port
    protocol    = var.front_sg_ingress_ssh_protocol
    cidr_blocks = var.front_sg_ingress_ssh_cird
  }
  
  ingress {
    description = var.front_sg_ingress_app_description
    from_port   = var.front_sg_ingress_app_port
    to_port     = var.front_sg_ingress_app_port
    protocol    = var.front_sg_ingress_app_protocol
    cidr_blocks = var.front_sg_ingress_app_cird
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
    "Name" = var.tag_responsible
  }
}


resource "aws_security_group" "sg-load-balancer-front" {
  name = "estudiantes_automatizacion_2021_4_front"
  description = var.lb_front_sg_description
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  ingress {
    description = var.lb_front_sg_in_traffic_description
    from_port   = var.lb_front_sg_in_traffic_port
    to_port     = var.lb_front_sg_in_traffic_port
    protocol    = var.lb_front_sg_in_traffic_protocol
    cidr_blocks = var.lb_front_sg_in_traffic_cird
  }


  ingress {
    description = var.front_sg_ingress_ssh_description
    from_port   = var.front_sg_ingress_ssh_port
    to_port     = var.front_sg_ingress_ssh_port
    protocol    = var.front_sg_ingress_ssh_protocol
    cidr_blocks = var.front_sg_ingress_ssh_cird
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


##EC2 Load Balancer
resource "aws_instance" "lb-front" {
  ami = var.ami_id
  subnet_id = "subnet-086d80cc0d3b06c82"
  instance_type = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.sg-load-balancer-front.id}"]
  user_data = base64encode(templatefile("./front.sh", {back_host = "localhost"}))


  tags = {
    Name = "estudiantes_automatizacion_2021_4_lb_front"
  }
}


##########################################
## Resource to create a launch template ##
##########################################

resource "aws_launch_template" "launch-template-front" {
  image_id               = var.ami_id
  name                   = var.front_launch_template_name
  instance_type          = var.front_launch_template_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [ aws_security_group.sg-front-instance.id ]

  user_data = base64encode(templatefile("./front.sh", {back_host = "localhost"}))

  tags = {
    Name = "estudiantes_automatizacion_2021_4_front"
  }

  tag_specifications {
    resource_type = "instance"
    
    tags = {
    Name = "estudiantes_automatizacion_2021_4_front"
    }
  }
}

##############################################
## Resource to create an auto scaling group ##
##############################################

resource "aws_autoscaling_group" "front-tf-asg" {
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = [ data.aws_subnet.public-subnet-a.id, data.aws_subnet.public-subnet-b.id ]
  ##target_group_arns   = [ aws_lb_target_group.front-target-group.arn ] ##Como especifico aqui que mi balanceador de carga es una ec2?

  launch_template {
    id      = aws_launch_template.launch-template-front.id
    version = "$Latest"
  }

  tags = [ {
    "responsible" = var.tag_responsible
    "name" = "estudiantes_automatizacion_2021_4_asg_front"

  } ]
}
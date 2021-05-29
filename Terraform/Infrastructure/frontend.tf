#######################################
## Resource to create security group ##
#######################################

##Preguntas: 
#Si yo no le puedo asignar una ip privada a las instancias del 
##launch template, como hago para que el lb apunte a ellas?
##Tengo que usar dos eip, una para el load balancer y otra para el nat gateway?



##Network

resource "aws_eip" "eip-lb" {
  vpc      = true
  
  tags = {
    Name = "estudiantes_automatizacion_2021_4"
  }
}

resource "aws_eip" "eip-ngw" {
  vpc  = true

  tags = {
    Name = "estudiantes_automatizacion_2021_4_ngw"
  }
}


resource "aws_route_table" "rt-public" {
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

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
  subnet_id     = data.aws_subnet.public-subnet-a.id
}

###Load balancer

resource "aws_lb_target_group" "front-target-group" {
  target_type = var.front_tg_target_type
  protocol    = var.front_tg_protocol
  port        = var.front_tg_port
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  # Los balanceadores de carga periodicamente envian solicitudes a sus objetivos registrados para probar su
  # status
  #  health_check {
  #   path                = "/"    # This is the destination for the health check request (you can specifya valid URI (/path?query))
  #   protocol            = "HTTP" # This is the protocol used to connect with the target
  #   matcher             = "200"  # The http code used when checking for a successful response from a target
  #    interval            = 30     # The amount of time between health checks of an individual target
  #    timeout             = 5      # The amount of time during which no response means a failed health check
  #    healthy_threshold   = 5      # This is the number of consecutive health checks successes requerid before considering an unhealthy target healthy
  #    unhealthy_threshold = 2      # This is the number of consecutive health checks failures requerid before considering the target unhealthy
  #  }

  tags = {
      responsible = var.tag_responsible
      Name = var.tag_responsible
  }
}

#####################################################
## Resource to create an application load balancer ##
#####################################################

resource "aws_lb" "front-tf-application-load-balancer" {
  name               = var.front_lb_name
  load_balancer_type = var.front_lb_type
  ##subnets            = [ data.aws_subnet.public_subnet_id_a.id, data.public_subnet_id_b.id ]
  ##security_groups    = [ aws_security_group.sg-load-balancer-front.id ]

  subnet_mapping {
    subnet_id     = data.aws_subnet.public-subnet-a.id
    allocation_id = aws_eip.eip-lb.id
  }

  subnet_mapping {
    subnet_id     = data.aws_subnet.public-subnet-b.id
  }

  tags = {
      "responsible" = var.tag_responsible
      "Name" = var.tag_responsible
  }
}


########################################
## Resource to create a listener rule ##
########################################

# Un listener es un proceso que comprueba las solicitudes de conexiónm utilizando el protocolo y el 
# puerto que configura. Las reglas que defina para un listener determinan cómo el balancercador de carga
# enruta las solicitudes a sus targets registrados 
resource "aws_lb_listener" "lbl_front" {
  load_balancer_arn = aws_lb.front-tf-application-load-balancer.arn
  protocol          = var.front_lbl_protocol
  port              = var.front_lbl_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front-target-group.arn
  }
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


##########################################
## Resource to create a launch template ##
##########################################

resource "aws_launch_template" "launch-template-front" {
  image_id               = var.ami_id
  name                   = var.front_launch_template_name
  instance_type          = var.front_launch_template_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [ aws_security_group.sg-front-instance.id ]

  user_data = base64encode(templatefile("./front.sh", {back_host = aws_lb.back-tf-application-lb.dns_name}))

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
  max_size            = 3
  min_size            = 3
  vpc_zone_identifier = [ data.aws_subnet.public-subnet-a.id, data.aws_subnet.public-subnet-b.id ]
  target_group_arns   = [ aws_lb_target_group.front-target-group.arn ]

  launch_template {
    id      = aws_launch_template.launch-template-front.id
    version = "$Latest"
  }

  tags = [ {
    "responsible" = var.tag_responsible
    "name" = "estudiantes_automatizacion_2021_4_asg_front"

  } ]
}
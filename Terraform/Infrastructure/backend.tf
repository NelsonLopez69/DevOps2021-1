###Backend####

resource "aws_security_group" "sg-back-instance" {
  name = "estudiantes_automatizacion_2021_4_back"
  description = var.back_sg_ingress_app_description
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  ingress {
    description = var.back_sg_ingress_ssh_description
    from_port   = var.back_sg_ingress_ssh_port
    to_port     = var.back_sg_ingress_ssh_port
    protocol    = var.back_sg_ingress_ssh_protocol
    cidr_blocks = var.back_sg_ingress_ssh_cird
  }
  
  ingress {
    description = var.back_sg_ingress_app_description
    from_port   = var.back_sg_ingress_app_port
    to_port     = var.back_sg_ingress_app_port
    protocol    = var.back_sg_ingress_app_protocol
    cidr_blocks = var.back_sg_ingress_app_cird
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


resource "aws_security_group" "sg-load-balancer-back" {
  name = "estudiantes_automatizacion_2021_back"
  description = var.lb_back_sg_description
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  ingress {
    description = var.lb_back_sg_in_traffic_description
    from_port   = var.lb_back_sg_in_traffic_port
    to_port     = var.lb_back_sg_in_traffic_port
    protocol    = var.lb_back_sg_in_traffic_protocol
    cidr_blocks = var.lb_back_sg_in_traffic_cird
  }


  ingress {
    description = var.lb_back_sg_in_ingress_ssh_description
    from_port   = var.lb_back_sg_in_ingress_ssh_port
    to_port     = var.lb_back_sg_in_ingress_ssh_port
    protocol    = var.lb_back_sg_in_ingress_ssh_protocol
    cidr_blocks = var.lb_back_sg_in_ingress_ssh_cird
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
    Name = "estudiantes_automatizacion_2021_4_lb_sg"
  }
}


###Load balancer

resource "aws_lb_target_group" "back-target-group" {
  target_type = var.back_tg_target_type
  protocol    = var.back_tg_protocol
  port        = var.back_tg_port
  vpc_id      = data.aws_vpc.grupo4-vpc.id

  # Los balanceadores de carga periodicamente envian solicitudes a sus objetivos registrados para probar su
  # status
  # health_check {
  #   path                = "/"    # This is the destination for the health check request (you can specifya valid URI (/path?query))
  #   protocol            = "HTTP" # This is the protocol used to connect with the target
  #   matcher             = "200"  # The http code used when checking for a successful response from a target
  #   interval            = 30     # The amount of time between health checks of an individual target
  #   timeout             = 5      # The amount of time during which no response means a failed health check
  #   healthy_threshold   = 5      # This is the number of consecutive health checks successes requerid before considering an unhealthy target healthy
  #   unhealthy_threshold = 2      # This is the number of consecutive health checks failures requerid before considering the target unhealthy
  # }

  tags = {
      "responsible" = var.tag_responsible
      "Name" = var.tag_responsible
  }
}

#####################################################
## Resource to create an application load balancer ##
#####################################################

resource "aws_lb" "back-tf-application-lb" {
  name               = var.back_lb_name
  internal           = true
  load_balancer_type = var.back_lb_type
  ##subnets            = [ data.aws_subnet.private-subnet-a.id, data.aws_subnet.private-subnet-b.id ]
  ##security_groups    = [ aws_security_group.sg-load-balancer-front.id ]

  subnet_mapping {
    subnet_id     = data.aws_subnet.private-subnet-a.id
    private_ipv4_address = "10.0.2.11"
  }

  subnet_mapping {
    subnet_id     = data.aws_subnet.private-subnet-b.id
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
resource "aws_lb_listener" "lbl_back" {
  load_balancer_arn = aws_lb.back-tf-application-lb.arn
  protocol          = var.back_lbl_protocol
  port              = var.back_lbl_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.back-target-group.arn
  }
}

##########################################
## Resource to create a launch template ##
##########################################

resource "aws_launch_template" "launch-template-back" {
  image_id               = var.ami_id
  name                   = var.back_launch_template_name
  instance_type          = var.back_launch_template_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [ aws_security_group.sg-back-instance.id ]


  user_data = base64encode(templatefile("./back.sh", {database_url = "http://admin:password@${aws_instance.db.private_ip}:5984"}))

  tags = {
    Name = "estudiantes_automatizacion_2021_4_back"
  }

  tag_specifications {
    resource_type = "instance"
    
    tags = {
    Name = "estudiantes_automatizacion_2021_4_back"
    }
  }
}

##############################################
## Resource to create an auto scaling group ##
##############################################

resource "aws_autoscaling_group" "back-tf-asg" {
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = [ data.aws_subnet.private-subnet-a.id, data.aws_subnet.private-subnet-b.id ]
  target_group_arns   = [ aws_lb_target_group.back-target-group.arn ]

  launch_template {
    id      = aws_launch_template.launch-template-back.id
    version = "$Latest"
  }

  tags = [ {
    "responsible" = var.tag_responsible
    "Name" = var.tag_responsible

  } ]
}


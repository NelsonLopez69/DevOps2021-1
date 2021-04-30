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


##EC2 Load Balancer
resource "aws_instance" "lb-back" {
  ami = var.ami_id
  subnet_id = "subnet-092430b94a12ef07e"
  instance_type = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.sg-load-balancer-back.id}"]
  user_data = base64encode(templatefile("./front.sh", {back_host = "localhost"}))

  tags = {
          Name = "estudiantes_automatizacion_2021_4_lb_back"
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


  user_data = base64encode(templatefile("./front.sh", {back_host = "localhost"}))

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

  launch_template {
    id      = aws_launch_template.launch-template-back.id
    version = "$Latest"
  }

  tags = [ {
    "responsible" = var.tag_responsible
    "Name" = var.tag_responsible

  } ]
}


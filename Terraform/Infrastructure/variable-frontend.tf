##############################
## Security group variables ##
##############################

#########
## SSH ##
#########

variable "front_sg_description" {
  type    = string
  default = "Security group for the front instance"
}

variable "front_sg_ingress_ssh_description" {
  type    = string
  default = "Allowed SSH from anywhere"
}

variable "front_sg_ingress_ssh_port" {
  type        = number
  default     = 22
  description = "This is the port for the inbound rule that allowed SSH to the frontend instance"
}

variable "front_sg_ingress_ssh_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed SSH to the frontend instance"
}

variable "front_sg_ingress_ssh_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}

#########
## APP ##
#########

variable "front_sg_ingress_app_description" {
  type        = string
  default     = "Allow traffic trough port 8080 from anywhere"
  description = "This is the description for the inbound rule that allowed traffic through the port 8080 from the internet to the frontend"
}

variable "front_sg_ingress_app_port" {
  type        = number
  default     = 8080
  description = "This is the port for the inbound rule that allowed traffic through the port 8080 from the internet to the frontend"
}

variable "front_sg_ingress_app_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed traffic through the port 8080 from the internet to the frontend"
}

variable "front_sg_ingress_app_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}

############################################
## Security group Load Balancer Variables ##
############################################

variable "lb_front_sg_description" {
  type    = string
  default = "load balancer security group"
}

variable "lb_front_sg_in_traffic_description" {
  type        = string
  default     = "Allowed traffic from anywhere"
  description = "This is the description for the inbound rule that allowed traffic to the load balancer"
}

variable "lb_front_sg_in_traffic_port" {
  type        = number
  default     = 0
  description = "This is the port for the inbound rule that allowed traffic to the load balancer"
}

variable "lb_front_sg_in_traffic_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed traffic to the load balancer"
}

variable "lb_front_sg_in_traffic_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}

#############################
## Load Balancer Variables ##
#############################

variable "front_lb_name" {
  type    = string 
  default = "front-tf-ALB"
}

variable "front_lb_type" {
  type    = string
  default = "network"
}

variable "front_lbl_protocol" {
  type    = string
  default = "HTTP"
}

variable "front_lbl_port" {
  type    = string
  default = 8080
}

############################
## Target Group Variables ##
############################

variable "front_tg_target_type" {
  type    = string
  default = "instance"
}

variable "front_tg_protocol" {
  type    = string 
  default = "HTTP"
}

variable "front_tg_port" {
  type    = number
  default = 8080
}

###############################
## Launch Template Variables ##
###############################

variable "front_launch_template_name" {
  type    = string
  default = "tf-launch-template-front-grupo4"
}

variable "front_launch_template_instance_type" {
  type    = string
  default = "t2.micro"
}


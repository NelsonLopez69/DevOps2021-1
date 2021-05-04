##############################
## Security group variables ##
##############################

#########
## SSH backend##
#########

variable "back_sg_description" {
  type    = string
  default = "Security group for the backend instance"
}

variable "back_sg_ingress_ssh_description" {
  type    = string
  default = "Allowed SSH from anywhere"
}

variable "back_sg_ingress_ssh_port" {
  type        = number
  default     = 22
  description = "This is the port for the inbound rule that allowed SSH to the backend instance"
}

variable "back_sg_ingress_ssh_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed SSH to the backend instance"
}

variable "back_sg_ingress_ssh_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}


#########
## APP ##
#########

variable "back_sg_ingress_app_description" {
  type        = string
  default     = "Allow traffic trough port 8089 from anywhere"
  description = "This is the description for the inbound rule that allowed traffic through the port 8089 from the internet to the backend"
}

variable "back_sg_ingress_app_port" {
  type        = number
  default     = 8089
  description = "This is the port for the inbound rule that allowed traffic through the port 8089 from the internet to the backend"
}

variable "back_sg_ingress_app_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed traffic through the port 8089 from the internet to the backend"
}

variable "back_sg_ingress_app_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}

############################################
## Security group Load Balancer Variables ##
############################################

variable "lb_back_sg_description" {
  type    = string
  default = "load balancer security group"
}

variable "lb_back_sg_in_traffic_description" {
  type        = string
  default     = "Allowed traffic from anywhere"
  description = "This is the description for the inbound rule that allowed traffic to the load balancer"
}

variable "lb_back_sg_in_traffic_port" {
  type        = number
  default     = 0
  description = "This is the port for the inbound rule that allowed traffic to the load balancer"
}

variable "lb_back_sg_in_traffic_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed traffic to the load balancer"
}

variable "lb_back_sg_in_traffic_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}


variable "lb_back_sg_in_ingress_ssh_description" {
  type    = string
  default = "Allowed SSH from anywhere"
}

variable "lb_back_sg_in_ingress_ssh_port" {
  type        = number
  default     = 22
  description = "This is the port for the inbound rule that allowed SSH to the backend instance"
}

variable "lb_back_sg_in_ingress_ssh_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed SSH to the backend instance"
}

variable "lb_back_sg_in_ingress_ssh_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}

###############################
## Launch Template Variables ##
###############################

variable "back_launch_template_name" {
  type    = string
  default = "tf-launch-template-back-grupo4"
}

variable "back_launch_template_instance_type" {
  type    = string
  default = "t2.micro"
}



#############################
## Load Balancer Variables ##
#############################

variable "back_lb_name" {
  type    = string 
  default = "back-tf-ALB"
}

variable "back_lb_type" {
  type    = string
  default = "network"
}

variable "back_lbl_protocol" {
  type    = string
  default = "TCP"
}

variable "back_lbl_port" {
  type    = string
  default = 8089
}

############################
## Target Group Variables ##
############################

variable "back_tg_target_type" {
  type    = string
  default = "instance"
}

variable "back_tg_protocol" {
  type    = string 
  default = "TCP"
}

variable "back_tg_port" {
  type    = number
  default = 8089
}

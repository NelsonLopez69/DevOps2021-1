##Database sg

#########
## SSH ##
#########

variable "db_description" {
  type    = string
  default = "Security group for the database instance"
}

variable "db_ingress_ssh_description" {
  type    = string
  default = "Allowed SSH from anywhere"
}

variable "db_ingress_ssh_port" {
  type        = number
  default     = 22
  description = "This is the port for the inbound rule that allowed SSH to the database instance"
}

variable "db_ingress_ssh_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed SSH to the database instance"
}


##Cambiar este ingress por la ip de las subnets private del back
variable "db_ingress_ssh_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}

#########
## APP ##
#########

##Cambiar al puerto de la db y el ingress cidr por el de las subnets pv
variable "db_ingress_app_description" {
  type        = string
  default     = "Allow traffic trough port wwwx from anywhere"
  description = "This is the description for the inbound rule that allowed traffic through the port wxxx from the backend to db"
}

variable "db_ingress_app_port" {
  type        = number
  default     = 8080
  description = "This is the port for the inbound rule that allowed traffic through the port 8080 from the backend to db"
}

variable "db_ingress_app_protocol" {
  type        = string
  default     = "tcp"
  description = "This is the protocol for the inbound rule that allowed traffic through the port wwx from the backend to db"
}

variable "db_ingress_app_cird" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
  description = "This is the list of CIDR"
}
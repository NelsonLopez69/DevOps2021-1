variable "aws_region" {
    type = string
    default = "us-east-2"
}


variable "vpc_id" {
    type = string
    default = "vpc-08088d2c954a0836f"
}

variable "public_subnet_id_a" {
    type = string
    default = "subnet-086d80cc0d3b06c82"
}

variable "public_subnet_id_b" {
    type = string
    default = "subnet-067b926f35bc72e5c"
}

variable "private_subnet_id_a" {
    type = string
    default = "subnet-092430b94a12ef07e"
}

variable "private_subnet_id_b" {
    type = string
    default = "	subnet-02429dfd9d6a0186b"
}

variable "ami_id" {
  type    = string
  default = "ami-08962a4068733a2b6"
}

variable "tag_responsible" {
  type    = string
  default = "estudiantes_automatizacion_2021_4"
}

variable "key_name" {
  type    = string
  default = "estudiantes_automatizacion_2021_4"
}
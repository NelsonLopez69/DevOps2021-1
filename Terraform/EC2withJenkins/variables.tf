variable "region" {
  type    = string
  default = "us-east-2"
}
variable "ami_id" {
  type = string
  default="ami-00399ec92321828f5"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key_name" {
  type    = string
  default = "estudiantes_automatizacion_2021_4"
}
variable "vpc_id" {
    type = string
    default = "vpc-08088d2c954a0836f"
}

variable "subnet_id_a" {
    type = string
    default = "subnet-086d80cc0d3b06c82"
}

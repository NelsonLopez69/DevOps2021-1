variable "region" {
  type    = string
  default = "us-east-2"
}
variable "ami_id" {
  type = string
  default="ami-05d72852800cbf29e"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key_name" {
  type    = string
  default = "estudiantes_automatizacion_2021_4"
}

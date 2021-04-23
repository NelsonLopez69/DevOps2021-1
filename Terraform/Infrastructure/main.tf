terraform {
  required_providers {
    aws = {
        source = "aws"
        version = "3.23.0"    
    }
  }
}

provider "aws" {
    region = var.aws_region
}

data "aws_vpc" "grupo4-vpc" {
    id = var.vpc_id
}

data "aws_subnet" "public-subnet-a" {
    id = var.public_subnet_id_a
}

data "aws_subnet" "public-subnet-b" {
    id = var.public_subnet_id_b
} 

data "aws_subnet" "private-subnet-a" {
    id = var.private_subnet_id_a
}

data "aws_subnet" "private-subnet-b" {
    id = var.private_subnet_id_b
} 


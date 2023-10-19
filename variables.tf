variable "environment_name" {
  default = "dev"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  default = "MISR_TEST"
}

variable "instance_key" {
  default = "MISR_KEY"
}

variable "ami" {
  default = "ami-0556fb70e2e8f34b7"
}

variable "myip" {
  default = "171.246.210.79"
}

variable "vpc_cidr_block" {
  default = "10.50.0.0/16"
}

variable "first_private_subnet_cidr" {
  default = "10.50.10.0/24"
}

variable "first_public_subnet_cidr" {
  default = "10.50.20.0/24"
}

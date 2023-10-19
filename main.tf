terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

module "custom-vpc" {
  source = "./modules/terraform-vpc"

  prefix         = var.environment_name
  separator      = "-"
  name           = "main"
  vpc_cidr_block = var.vpc_cidr_block

  first_private_subnet_cidr  = var.first_private_subnet_cidr

  first_public_subnet_cidr  = var.first_public_subnet_cidr
}

module "custom_security_group" {
  source     = "./modules/custom-security-group"
  allowed_ip = "171.246.210.79"
  vpc_id     = module.custom-vpc.vpc_id # Replace with your VPC ID
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "MISR_1" {
  ami                    = var.ami           # Amazon Linux 2 AMI ID
  instance_type          = var.instance_type # Instance type (small, free tier eligible)
  key_name               = "MISR_KEY"        # Your SSH key pair name (replace with your own)
  subnet_id              = module.custom-vpc.public_subnet_ids
  security_groups        = [module.custom-security-group.security_group_id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.instance_name}_1_PROXY"
  }
}

resource "aws_instance" "MISR_2" {
  ami                    = var.ami           # Amazon Linux 2 AMI ID
  instance_type          = var.instance_type # Instance type (small, free tier eligible)
  key_name               = "MISR_KEY"        # Your SSH key pair name (replace with your own)
  subnet_id              = module.custom-vpc.public_subnet_ids
  security_groups        = [module.custom-security-group.security_group_id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.instance_name}_2_APPLICATION"
  }
}

#resource "aws_instance" "MISR_3" {
#  ami                    = var.ami           # Amazon Linux 2 AMI ID
#  instance_type          = var.instance_type # Instance type (small, free tier eligible)
#  key_name               = "MISR_KEY"        # Your SSH key pair name (replace with your own)
#  subnet_id              = module.custom-vpc.private_subnet_ids
#  security_groups        = [module.custom-security-group.security_group_id]
#  associate_public_ip_address = true
#  tags = {
#    Name = "${var.instance_name}_3_DATABASE"
#  }
#}
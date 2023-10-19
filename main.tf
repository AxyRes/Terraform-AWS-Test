provider "aws" {
  region = "ap-southeast-1"
}

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
  allowed_ip = var.myip
  vpc_id     = module.custom-vpc.vpc_id # Replace with your VPC ID
}

#module "custom-alb" {
#  source = "./modules/terraform-loadbalancer"

#  alb_name                = "my-application-lb"
#  internal                = false
#  subnet_ids              = module.custom-vpc.public_subnet_ids
#  security_group_ids      = [module.custom-security-group.security_group_id]
#  enable_deletion_protection = false
#  enable_http2            = true
#}

resource "aws_instance" "terraform_instance_1" {
  ami                    = var.ami           # Amazon Linux 2 AMI ID
  instance_type          = var.instance_type # Instance type (small, free tier eligible)
  key_name               = var.instance_key       # Your SSH key pair name (replace with your own)
  subnet_id              = module.custom-vpc.public_subnet_ids
  security_groups        = [module.custom-security-group.security_group_id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.instance_name}_1_PROXY"
  }
}

resource "aws_instance" "terraform_instance_2" {
  ami                    = var.ami           # Amazon Linux 2 AMI ID
  instance_type          = var.instance_type # Instance type (small, free tier eligible)
  key_name               = var.instance_key       # Your SSH key pair name (replace with your own)
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

#resource "aws_lb_listener" "load_balancer" {
#  load_balancer_arn = module.my_alb.alb_arn
#  port             = 80
#  protocol         = "HTTP"
#  default_action {
#    type             = "fixed-response"
#    fixed_response {
#      content_type = "text/plain"
#      status_code  = "200"
#    }
#  }
#}
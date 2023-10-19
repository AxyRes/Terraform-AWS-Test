locals {
  base_name = "${var.prefix}${var.separator}${var.name}"
}

## Create VPC ##
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = local.base_name
  }
}

## Declare AZ in this region. We always assume 3 are available ##
data "aws_availability_zones" "available" {}

## Create Private Subnets ##
resource "aws_subnet" "first_private_az" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.first_private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${local.base_name} Private Network First AZ"
  }
}

resource "aws_subnet" "first_public_az" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.first_public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "${local.base_name} Public Network First AZ"

  }

}

## Create Internet Gateway ##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${local.base_name} Internet Gateway"

  }

}

## Create Routing table for the public subnets ##
resource "aws_route_table" "public-route-to-igw" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "${local.base_name} Public Routing Table"

  }
}

resource "aws_route" "public_subnet_internet_gateway_ipv4" {
  route_table_id         = aws_route_table.public-route-to-igw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

## Associate Routing table to the public subnets ##
resource "aws_route_table_association" "public_AZ1" {
  subnet_id      = aws_subnet.first_public_az.id
  route_table_id = aws_route_table.public-route-to-igw.id
}

resource "aws_eip" "public_AZ1" {
  vpc = true
}

## Create NAT Gateways ##
resource "aws_nat_gateway" "nat_AZ1" {
  allocation_id = aws_eip.public_AZ1.id
  subnet_id     = aws_subnet.first_public_az.id

  depends_on = [aws_internet_gateway.igw]

  tags = { Name = "${local.base_name} First AZ NAT Gateway"

  }
}

## Create NAT Routing tables for the private subnets ##
resource "aws_route_table" "private-route-to-nat-gw_AZ1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.base_name} Private Routing Table First AZ"
  }
}

resource "aws_route" "private_subnet_nat_gateway_AZ1" {
  route_table_id         = aws_route_table.private-route-to-nat-gw_AZ1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_AZ1.id
}

resource "aws_route_table_association" "private_AZ1" {
  subnet_id      = aws_subnet.first_private_az.id
  route_table_id = aws_route_table.private-route-to-nat-gw_AZ1.id
}
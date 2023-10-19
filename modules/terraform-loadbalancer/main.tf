resource "aws_lb" "load_balancer" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
}
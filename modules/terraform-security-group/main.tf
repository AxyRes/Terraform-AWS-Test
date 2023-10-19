resource "aws_security_group" "allow_all" {
  name        = "allow-all-from-${var.allowed_ip}"
  description = "Allow all incoming and outgoing traffic from ${var.allowed_ip}"
  vpc_id      = module.custom-vpc.vpc_id

  // Ingress rule to allow all incoming traffic from the specified IP
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  // Egress rule to allow all outgoing traffic to the specified IP
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }
}
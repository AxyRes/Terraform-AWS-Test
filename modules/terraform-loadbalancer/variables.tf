variable "alb_name" {
}

variable "internal" {
}

variable "subnet_ids" {
  type        = list(string)
}

variable "security_group_ids" {
  type        = list(string)
}

variable "enable_deletion_protection" {
  type        = bool
}

variable "enable_http2" {
  type        = bool
}

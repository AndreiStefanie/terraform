variable "aws_region" {
  default = "eu-north-1"
}

variable "access_ip" {
  type        = string
  description = "IP for SSH access"
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_pass" {
  type      = string
  sensitive = true
}

variable "public_key_path" {
  type = string
}

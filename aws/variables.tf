variable "aws_region" {
  default = "eu-west-1"
}

variable "access_ip" {
  type        = string
  description = "IP for SSH access"
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_pass" {
  type = string
}

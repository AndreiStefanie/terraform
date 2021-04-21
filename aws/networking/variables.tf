variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}

variable "access_ip" {
  type = string
}

variable "security_groups" {}

variable "add_db_sng" {
  type = bool
}

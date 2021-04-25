locals {
  azs = data.aws_availability_zones.tf_azs.names
}

locals {
  any_ip = "0.0.0.0/0"
}

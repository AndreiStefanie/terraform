locals {
  vpc_cidr = "10.124.0.0/16"
}

locals {
  any_ip = "0.0.0.0/0"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Allow public traffic"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [local.any_ip]
        }
      }
    }

    db = {
      name        = "db_sg"
      description = "Allow database traffic"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}

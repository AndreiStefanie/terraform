locals {
  vpc_cidr = "10.124.0.0/16"
}

locals {
  any_ip = "0.0.0.0/0"
}

locals {
  app_port = 8080
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Allow public traffic"
      ingress = {
        ctl = {
          from        = 0
          to          = 0
          protocol    = "-1"
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [local.any_ip]
        }
        nginx = {
          from        = local.app_port
          to          = local.app_port
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

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  add_db_sng       = true
}

module "database" {
  source                 = "./database"
  db_storage             = 10
  db_engine_version      = "5.7.22"
  db_instance_class      = "db.t2.micro"
  db_name                = var.db_name
  db_user                = var.db_user
  db_pass                = var.db_pass
  db_identifier          = "tf-db"
  db_subnet_group_name   = module.networking.db_subnet_group_names[0]
  vpc_security_group_ids = module.networking.db_security_group_ids
  skip_db_snapshot       = true
}

module "loadbalancer" {
  source              = "./loadbalancer"
  public_subnets      = module.networking.public_subnets
  public_sg           = module.networking.public_sg
  port                = local.app_port
  protocol            = "HTTP"
  vpc_id              = module.networking.vpc_id
  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout             = 3
  interval            = 30
  listener_port       = 80
}

module "compute" {
  source           = "./compute"
  instance_count   = 1
  instance_type    = "t2.micro"
  public_sg        = module.networking.public_sg
  public_subnets   = module.networking.public_subnets
  volume_size      = 10
  key_name         = "tfkey"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  user_data_path   = "${path.root}/scripts/userdata.tpl"
  db_name          = var.db_name
  db_user          = var.db_user
  db_pass          = var.db_pass
  db_endpoint      = module.database.endpoint
  target_group_arn = module.loadbalancer.target_group_arn
  tg_port          = local.app_port
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr         = var.vpc_cidr
  vpc_name         = var.vpc_name
  public_subnets   = var.public_subnets
  private_subnets = var.private_subnets
}

module "ec2" {
  source          = "./modules/ec2"
  instance_name   = var.instance_name
  instance_type   = var.instance_type
  instance_count  = var.instance_count
  subnet_ids      = module.vpc.public_subnets
  key_name        = var.key_name
  vpc_id = module.vpc.vpc_id
}

# module "rds" {
#   source           = "./modules/rds"
#   db_username      = var.db_username
#   db_password      = var.db_password
# }
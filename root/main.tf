module "vpc" {
  source          = "../modules/vpc"
  PROJECT_NAME    = var.PROJECT_NAME
  REGION          = var.REGION
  CIDR            = var.CIDR
  PUB-SUB-1-CIDR  = var.PUB-SUB-1-CIDR
  PUB-SUB-2-CIDR  = var.PUB-SUB-2-CIDR
  PRIV-SUB-1-CIDR = var.PRIV-SUB-1-CIDR
  PRIV-SUB-2-CIDR = var.PRIV-SUB-2-CIDR
}


module "nat" {
  source        = "../modules/nat"
  VPC-ID        = module.vpc.VPC-ID
  PROJECT_NAME  = var.PROJECT_NAME
  PUB-SUB-1-ID  = module.vpc.PUB-SUB-1-ID
  PUB-SUB-2-ID  = module.vpc.PUB-SUB-2-ID
  PRIV-SUB-1-ID = module.vpc.PRIV-SUB-1-ID
  PRIV-SUB-2-ID = module.vpc.PRIV-SUB-2-ID
  IGW-ID        = module.vpc.IGW-ID
}

module "sg" {
  source = "../modules/security groups"
  VPC-ID = module.vpc.VPC-ID
}

module "route_53" {
  source      = "../modules/route 53"
  DOMAIN_NAME = var.DOMAIN_NAME
  HOSTED_ZONE = var.HOSTED_ZONE
  ALB_DNS     = module.alb.ALB-DNS
  ALB-ZONE-ID = module.alb.ALB-ZONE-ID
  RECORD_NAME = var.RECORD_NAME
}
module "alb" {
  source       = "../modules/alb"
  VPC_ID       = module.vpc.VPC-ID
  ALB-SG       = module.sg.ALB-SG-ID
  PUB-SUB-1-ID = module.vpc.PUB-SUB-1-ID
  PUB-SUB-2-ID = module.vpc.PUB-SUB-2-ID
  PROJECT_NAME = var.PROJECT_NAME
  CER-ARN      = module.route_53.Certificate-ARN
}
module "asg" {
  source           = "../modules/asg"
  DESIRED_CAPACITY = var.DESIRED_CAPACITY
  MIN_SIZE         = var.MIN_SIZE
  MAX_SIZE         = var.MAX_SIZE
  PUB-SUB-1-ID     = module.vpc.PUB-SUB-1-ID
  PUB-SUB-2-ID     = module.vpc.PUB-SUB-2-ID
  INSTANCE_TYPE    = var.INSTANCE_TYPE
  PROJECT_NAME     = var.PROJECT_NAME
  AMI              = var.AMI
  TG-ARN           = module.alb.TG-ARN
  WEB_SG_ID        = module.sg.WEB-SG-ID
}


module "rds" {
  source        = "../modules/rds"
  PRIV-SUB-1-ID = module.vpc.PRIV-SUB-1-ID
  PRIV-SUB-2-ID = module.vpc.PRIV-SUB-2-ID
  DB_SUB_NAME   = var.DB_SUB_NAME
  DB-USER       = var.DB-USER
  DB-PASS       = var.DB-PASS
  DB-NAME       = var.DB-NAME
  DB_SG_ID      = module.sg.DB-SG-ID
}

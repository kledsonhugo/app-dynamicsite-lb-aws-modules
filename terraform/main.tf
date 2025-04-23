module "network" {
  source           = "./modules/network"
  vpc_cidr         = "10.0.0.0/16"
  subnet_az1a_cidr = "10.0.1.0/24"
  subnet_az1b_cidr = "10.0.2.0/24"
}

module "compute" {
  source         = "./modules/compute"
  ec2_ami        = "ami-00a929b66ed6e0de6"
  vpc_cidr       = "10.0.0.0/16"
  vpc_id         = module.network.vpc_id
  subnet_az1a_id = module.network.subnet_az1a_id
  subnet_az1b_id = module.network.subnet_az1b_id
}
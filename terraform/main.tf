# ORCHESTRATOR

module "network" {
    source           = "./modules/network"
    vpc_cidr         = "30.0.0.0/16"
    subnet_az1a_cidr = "30.0.1.0/24"
    subnet_az1b_cidr = "30.0.2.0/24"
}

module "compute" {
    source         = "./modules/compute"
    ec2_ami        = "ami-0c101f26f147fa7fd"
    vpc_cidr       = "30.0.0.0/16"
    vpc_id         = "${module.network.vpc_id}"
    subnet_az1a_id = "${module.network.subnet_az1a_id}"
    subnet_az1b_id = "${module.network.subnet_az1b_id}"
}
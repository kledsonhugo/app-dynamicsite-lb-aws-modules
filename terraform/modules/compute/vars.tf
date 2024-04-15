# NETWORK VARS DEFAULT VALUES

# COMPUTE VARS DEFAULT VALUES

variable "ec2_ami" {
    type    = string
    default = "ami-02e136e904f3da870"
}

# INPUT IS REQUIRED BECAUSE NO DEFAULT IS DEFINED

variable "vpc_cidr" {}
variable "vpc_id" {}
variable "subnet_az1a_id" {}
variable "subnet_az1b_id" {}
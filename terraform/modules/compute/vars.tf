variable "ec2_ami" {
  type    = string
  default = "ami-02e136e904f3da870"
}

variable "key_name" {
  type    = string
  default = "vockey"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_cidr" {}
variable "vpc_id" {}
variable "subnet_az1a_id" {}
variable "subnet_az1b_id" {}
variable "vpc_cidr" {
    type    = string
    default = "20.0.0.0/16"
}

variable "subnet_az1a_cidr" {
    type    = string
    default = "20.0.1.0/24"
}

variable "subnet_az1b_cidr" {
    type    = string
    default = "20.0.2.0/24"
}
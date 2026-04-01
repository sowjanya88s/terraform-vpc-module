variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_tags" {
    type = map
    default = {}
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "igw_tags" {
    type = map
    default = {}
}

variable "public_cidr_block" {
    type = list
    default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "subnet_tags" {
    type = map
    default = {}
}

variable "private_cidr_block" {
    type = list
    default = ["10.0.11.0/24" , "10.0.12.0/24"]
}

variable "database_cidr_block" {
    type = list
    default = ["10.0.21.0/24" , "10.0.22.0/24"]
}

variable "route_table_tags" {
    type = map
    default = {}
}

variable "is_peering_required" {
    type = bool
    default = false
}
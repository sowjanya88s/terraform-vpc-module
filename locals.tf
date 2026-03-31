locals {
    vpc_final_tags = merge(local.common_tags , var.vpc_tags)
    common_tags = {
        terraform = "true"
    }
  igw_final_tags = merge(local.common_tags , var.igw_tags)
  az_names = slice(data.aws_availability_zones.available.names , 0 , 2)
  
}
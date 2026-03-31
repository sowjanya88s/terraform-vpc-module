locals {
    vpc_final_tags = merge(local.common_tags , var.vpc_tags)
    common_tags = {
        terraform = "true"
        Name = "${var.project}-${var.environment}"
    }
  igw_final_tags = merge(local.common_tags , var.igw_tags)

}
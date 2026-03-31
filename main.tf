resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = local.igw_final_tags
}

resource "aws_subnet" "public" {
    count = length(var.cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available

  tags = {
    Name = "${var.project}-${var.environment}-dev-"
  }
}
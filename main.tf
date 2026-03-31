resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = var.vpc_final_tags
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = var.igw_final_tags
}

resource "aws_subnet" "public" {
    count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags ,
    {
    #roboshop-dev-public-us-east-1
    Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
  },
  var.subnet_tags
  )
}

resource "aws_subnet" "private" {
    count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = local.az_names[count.index]
  
  tags = merge(
    local.common_tags ,
    {
    #roboshop-dev-private-us-east-1
    Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
  },
  var.subnet_tags
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_block[count.index]
  availability_zone = local.az_names[count.index]
  
  tags = merge(
    local.common_tags ,
    {
    #roboshop-dev-database-us-east-1
    Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
  },
  var.subnet_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-public-rt"
    },
    var.route_table_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-private-rt"
    },
    var.route_table_tags
  )
}

resource "aws_route" "public_route" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}


resource "aws_eip" "lb" {
 domain       = "vpc"
 tags = (
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-elastic-ip"
    }
  )
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id
  tags = (
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-nat"
    }
  )
}

resource "aws_route" "private_route" {
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.gw.id
}

resource "aws_route" "database_route" {
  route_table_id              = aws_route_table.database.id
  destination_ipv6_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.gw.id
}
resource "aws_vpc_peering_connection" "roboshop-default" {
    count = var.is_peering_required ? 1 : 0
  # peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = data.aws_vpc.default_vpc.id
  
  tags = {
    Name = "roboshop-default"
  }
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "roboshop-public-route" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop-default[count.index].id
}

resource "aws_route" "default-route" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.default_main.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop-default[count.index].id
}

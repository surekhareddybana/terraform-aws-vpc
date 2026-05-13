resource "aws_vpc_peering_connection" "default" {
    count = var.is_peering_required ? 1 : 0 # if true is given count 1 if u give false count 0 then resource will not be created
  
  peer_vpc_id   = data.aws_vpc.default.id #acceptor  vpc which is default hear
  vpc_id        = aws_vpc.main.id #requestor

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  auto_accept = true # same account in 2 vpc 
  tags = merge (
    var.vpc_peering_tags,
    local.common_tags,
    {
        Name = "${var.project}-${var.enviornment}-default"
    }
  )
}
#this peering roboshop-vpc to default vpc
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
    route_table_id  = aws_route_table.public.id
    destination_cidr_block = data.aws_vpc.default.cidr_block #this is default vpc cidr_range through peering
    gateway_id = aws_internet_gateway.main.id
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "private_peering" {
     count = var.is_peering_required ? 1 : 0
    route_table_id  = aws_route_table.public.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    gateway_id = aws_internet_gateway.main.id
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}
resource "aws_route" "database_peering" {
    count = var.is_peering_required ? 1 : 0
    route_table_id  = aws_route_table.public.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    gateway_id = aws_internet_gateway.main.id
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

# we should add peering  connection in default vpc main route table  too

resource "aws_route" "default_peering" {
     count = var.is_peering_required ? 1 : 0
    route_table_id  = data.aws_route_table.main.id #this is main route table of acceptor i mean default
    destination_cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.main.id
    vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

/**
該当のVPCにInternateGateWayがアタッチされていない場合

resource "aws_internet_gateway" "gateway" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "MyGateWay"
  }
}
*/

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(data.aws_subnets.public.ids)
  allocation_id = element(aws_eip.natgateway, count.index).id
  subnet_id     = sort(data.aws_subnets.public.ids)[count.index] # aws_subnetsはSet要素なのでsortでリストに変換
  tags = {
    Name = "MyNatGateWay"
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }
}

resource "aws_route_table" "private" {
  count  = length(data.aws_subnets.private.ids)
  vpc_id = data.aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw, count.index).id
  }
}

resource "aws_route_table_association" "private" {
  count          = length(data.aws_subnets.private.ids)
  route_table_id = element(aws_route_table.private, count.index).id
  subnet_id      = sort(data.aws_subnets.private.ids)[count.index]
}
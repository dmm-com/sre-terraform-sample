
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc"] # 事前に対象のサブネット（10.1.0.0/24?）に名前を設定してください
  }
  /*
  filterの代わりにこういうやり方もありです
  id = "vpc-074401f847d4833fa"
  */
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["public-*"] # 実弾演習の初期設定に合わせた名前になっています
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private-*"] # 実弾演習の初期設定に合わせた名前になっています
  }
}

/*
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id
}
*/

# 確認用のデバックメッセージ
output "public_subnet_cidr_blocks" {
  value = data.aws_subnets.public.ids
}

# 確認用のデバックメッセージ
output "private_subnet_cidr_blocks" {
  value = data.aws_subnets.private.ids
}

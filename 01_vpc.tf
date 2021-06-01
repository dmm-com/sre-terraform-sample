
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc"] # 事前に対象のサブネット（10.1.0.0/24?）に名前を設定してください
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["public-*"] # 実弾演習の初期設定に合わせた名前になっています
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id
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
  value = data.aws_subnet_ids.public.ids
}

# 確認用のデバックメッセージ
output "private_subnet_cidr_blocks" {
  value = data.aws_subnet_ids.private.ids
}

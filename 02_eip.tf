resource "aws_eip" "natgateway" {
  count = length(data.aws_subnets.public.ids)
  vpc   = true
}

// bastionのIPはec2.tfで管理しています
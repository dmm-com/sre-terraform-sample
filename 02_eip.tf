resource "aws_eip" "natgateway" {
  count  = length(data.aws_subnets.public.ids)
  domain = "vpc"
}

// bastionのIPはec2.tfで管理しています
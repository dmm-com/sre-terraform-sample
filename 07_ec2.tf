
locals {
  bastion_units = 1
}

resource "aws_instance" "ec2_web" {
  count                  = 2
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = sort(data.aws_subnets.private.ids)[count.index % 2]
  vpc_security_group_ids = [aws_security_group.ec2_web.id]
  key_name               = aws_key_pair.auth.id
  user_data              = file("./user_data.sh")
  tags = {
    Name = "web-${count.index + 1}"
  }
}

resource "aws_instance" "ec2_bastion" {
  count                  = local.bastion_units
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = sort(data.aws_subnets.public.ids)[count.index % 2]
  vpc_security_group_ids = [aws_security_group.ec2_bastion.id]
  key_name               = aws_key_pair.auth.id
  user_data              = file("./user_data.sh")
  tags = {
    Name = "bastion-${count.index + 1}"
  }
}

resource "aws_eip" "bastion" {
  count    = local.bastion_units
  instance = element(aws_instance.ec2_bastion, count.index).id
  domain   = "vpc"
}
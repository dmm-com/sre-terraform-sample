resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "tag:Name"
  }
}

resource "aws_subnet" "public_1a" {
  # 先程作成したVPCを参照し、そのVPC内にSubnetを立てる
  vpc_id = "${aws_vpc.vpc.id}"

  # Subnetを作成するAZ
  availability_zone = "us-east-1a"

  cidr_block        = "192.168.1.0/24"

  tags = {
    Name = "public_1a"
  }
}

resource "aws_subnet" "public_1b" {
  # 先程作成したVPCを参照し、そのVPC内にSubnetを立てる
  vpc_id = "${aws_vpc.vpc.id}"

  # Subnetを作成するAZ
  availability_zone = "us-east-1b"

  cidr_block        = "192.168.2.0/24"

  tags = {
    Name = "public_1b"
  }
}


resource "aws_subnet" "private_1c" {
  # 先程作成したVPCを参照し、そのVPC内にSubnetを立てる
  vpc_id = "${aws_vpc.vpc.id}"

  # Subnetを作成するAZ
#  availability_zone = "us-east-1c"
#
  cidr_block        = "192.168.3.0/24"

  tags = {
    Name = "private_1c"
  }
}

resource "aws_subnet" "private_1d" {
  # 先程作成したVPCを参照し、そのVPC内にSubnetを立てる
  vpc_id = "${aws_vpc.vpc.id}"

  # Subnetを作成するAZ
  availability_zone = "us-east-1d"

  cidr_block        = "192.168.4.0/24"

  tags = {
    Name = "public_1d"
  }
}

# Internet Gateway
# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "inetgw"
  }
}
#
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "aws-public"
  }
}
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.public.id}"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = "${aws_subnet.public_1b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# Elastic IP
# https://www.terraform.io/docs/providers/aws/r/eip.html
resource "aws_eip" "nateip_1a" {
  vpc = true

  tags = {
    Name = "nateip-1a"
  }
}
resource "aws_eip" "nateip_1b" {
  vpc = true

  tags = {
    Name = "nateip-1b"
  }
}

# NAT Gateway
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "natgw_1a" {
  subnet_id     = "${aws_subnet.public_1a.id}" # NAT Gatewayを配置するSubnetを指定
  allocation_id = "${aws_eip.nateip_1a.id}"       # 紐付けるElasti IP

  tags = {
    Name = "natgw-1a"
  }
}

# NAT Gateway
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "natgw_1b" {
  subnet_id     = "${aws_subnet.public_1b.id}" # NAT Gatewayを配置するSubnetを指定
  allocation_id = "${aws_eip.nateip_1b.id}"       # 紐付けるElasti IP

  tags = {
    Name = "natgw-1b"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "private-1c"
  }
}

resource "aws_route_table" "private_1d" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "private-1d"
  }
}

resource "aws_route" "private_1c" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private_1c.id}"
  nat_gateway_id         = "${aws_nat_gateway.natgw_1a.id}"
}

resource "aws_route" "private_1d" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private_1d.id}"
  nat_gateway_id         = "${aws_nat_gateway.natgw_1b.id}"
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = "${aws_subnet.private_1c.id}"
  route_table_id = "${aws_route_table.private_1c.id}"
}

resource "aws_route_table_association" "private_1d" {
  subnet_id      = "${aws_subnet.private_1d.id}"
  route_table_id = "${aws_route_table.private_1d.id}"
}

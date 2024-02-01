resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.project_tags
}

resource "aws_subnet" "public-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-south-1a"

  tags = merge(var.project_tags, {
    Name = "public-subnet-1"
  })
}

resource "aws_subnet" "public-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-south-1b"

  tags = merge(var.project_tags, {
    Name = "public-subnet-2"
  })
}

resource "aws_subnet" "private-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-south-1a"

  tags = merge(var.project_tags, {
    Name = "private-subnet-1"
  })
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-south-1b"

  tags = merge(var.project_tags, {
    Name = "private-subnet-2"
  })
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "internet gw"
  }, var.project_tags)
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public-1.id

}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(var.project_tags, {
    Name = "public-route-table"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = merge(var.project_tags, {
    Name = "private-route-table"
  })
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.project_tags, {
    Name = "public-nacl"
  })
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.project_tags, {
    Name = "private-nacl"
  })

}

resource "aws_network_acl_association" "public-1" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public-1.id
}

resource "aws_network_acl_association" "public-2" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public-2.id
}

resource "aws_network_acl_association" "private-1" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private-1.id
}

resource "aws_network_acl_association" "private-2" {
  network_acl_id = aws_network_acl.private.id
  subnet_id      = aws_subnet.private-2.id
}
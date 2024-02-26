resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_test"
  }
}

resource "aws_subnet" "subnet_public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Main1"
  }
}

resource "aws_subnet" "subnet_public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Main2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "awsrt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "positive_rta1" {
  subnet_id      = aws_subnet.subnet_public1.id
  route_table_id = aws_route_table.awsrt.id
}

resource "aws_route_table_association" "positive_rta2" {
  subnet_id      = aws_subnet.subnet_public2.id
  route_table_id = aws_route_table.awsrt.id
}

resource "aws_route" "awsroute" {
  route_table_id         = aws_route_table.awsrt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_eip" "elastic_ip_nat_gateway" {
  # vpc_id                      = true
  associate_with_private_ip = "10.0.0.10"

  tags = {
    name = "hr-app"
  }
}

########private networks#########
resource "aws_subnet" "subnet_private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Main1"
  }
}

resource "aws_subnet" "subnet_private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Main2"
  }
}

resource "aws_route_table" "negative_awsrt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "negative_rta3" {
  subnet_id      = aws_subnet.subnet_private1.id
  route_table_id = aws_route_table.negative_awsrt.id
}


resource "aws_route_table_association" "negative_rta4" {
  subnet_id      = aws_subnet.subnet_private2.id
  route_table_id = aws_route_table.negative_awsrt.id
}
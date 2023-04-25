resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Jenkins-project-VPC"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.1.0/24"
}
resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-west-2b"
  cidr_block        = "10.0.2.0/24"
}
resource "aws_subnet" "public3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-west-2c"
  cidr_block        = "10.0.3.0/24"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Project VPC IG"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.rt.id
}
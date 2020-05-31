provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
}

################ VPC #################
resource "aws_vpc" "vpc" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.environment_name
  }
}

######## IGW ###############
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "main-igw"
  }
}

################# Subnets #############
resource "aws_subnet" "pub_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.environment_name} Public Subnet (AZ1)"
  }
}

resource "aws_subnet" "pub_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.environment_name} Public Subnet (AZ2)"
  }
}

resource "aws_subnet" "priv_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.environment_name} Private Subnet (AZ1)"
  }
}

resource "aws_subnet" "priv_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.environment_name} Private Subnet (AZ2)"
  }
}

########### NAT ##############
resource "aws_eip" "nat1" {
}

resource "aws_eip" "nat2" {
}

resource "aws_nat_gateway" "natgw-1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.pub_subnet_1.id

  tags = {
    Name = "${var.environment_name} Public Subnet (AZ1) NAT"
  }
}

resource "aws_nat_gateway" "natgw-2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.pub_subnet_2.id

  tags = {
    Name = "${var.environment_name} Public Subnet (AZ2) NAT"
  }
}

############# Route Tables ##########
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "${var.environment_name} Public Route"
  }
}

resource "aws_route_table" "private-rt-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-1.id
  }

  tags = {
    Name = "${var.environment_name} Private Route"
  }
}

resource "aws_route_table" "private-rt-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-2.id
  }

  tags = {
    Name = "${var.environment_name} Private Route"
  }
}

######### PUBLIC Subnet assiosation with rotute table    ######
resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public-assoc-2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.public-rt.id
}

########## PRIVATE Subnets assiosation with rotute table ######
resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = aws_subnet.priv_subnet_1.id
  route_table_id = aws_route_table.private-rt-1.id
}

resource "aws_route_table_association" "private-assoc-2" {
  subnet_id      = aws_subnet.priv_subnet_2.id
  route_table_id = aws_route_table.private-rt-2.id
}
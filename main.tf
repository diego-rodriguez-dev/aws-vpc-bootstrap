provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnets_config)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets_config.*.cidr, count.index)
  availability_zone       = element(var.private_subnets_config.*.availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-${element(var.private_subnets_config.*.availability_zone, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets_config)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets_config.*.cidr, count.index)
  availability_zone       = element(var.public_subnets_config.*.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${element(var.public_subnets_config.*.availability_zone, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}

#Internet gateway
resource "aws_internet_gateway" "ig" {
  count  = length(var.public_subnets_config) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.environment}-igw"
    "Environment" = var.environment
  }
}

# Elastic-IP (eip) for NAT, 1 for each public subnet
resource "aws_eip" "nat_eip" {
  count      = var.create_nat_gateway && length(var.private_subnets_config) > 0 ? length(var.public_subnets_config) : 0
  depends_on = [aws_internet_gateway.ig]
}

# NAT Gateways, 1 for each public subnet
resource "aws_nat_gateway" "nat" {
  count         = length(aws_eip.nat_eip)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  tags = {
    Name        = "nat-gateway-${var.environment}-${element(aws_subnet.public_subnet.*.id, count.index)}"
    Environment = "${var.environment}"
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  count  = length(var.private_subnets_config)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-private-route-table-${count.index}"
    Environment = "${var.environment}"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  count  = length(var.public_subnets_config) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  count                  = length(var.public_subnets_config) > 0 ? 1 : 0
  route_table_id         = element(aws_route_table.public.*.id, 0)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_internet_gateway.ig.*.id, 0)
}

# Route table associations for both Public subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_config)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, 0)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_config)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Route for NAT Gateways to private route table
resource "aws_route" "private_internet_gateway" {
  count                  = length(aws_eip.nat_eip)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_nat_gateway.nat.*.id, count.index)
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.name}-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  # Chỉ tạo IGW, không gắn vào VPC ở đây
  tags = { Name = "${var.name}-igw" }
}

# Sử dụng tài nguyên riêng để gắn IGW vào VPC
resource "aws_internet_gateway_attachment" "igw_attachment" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.this.id
}

# Public Subnets (one per AZ)
resource "aws_subnet" "public" {
  for_each                = zipmap(var.azs, var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name}-public-${each.key}" }
}

# Private Subnets (one per AZ)
resource "aws_subnet" "private" {
  for_each                = zipmap(var.azs, var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.name}-private-${each.key}" }
}

# Elastic IPs for NAT (one per AZ)
resource "aws_eip" "nat" {
  for_each = toset(var.azs)
}

# NAT Gateways (one per AZ, placed in corresponding public subnet)
resource "aws_nat_gateway" "nat" {
  for_each      = toset(var.azs)
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = { Name = "${var.name}-nat-${each.key}" }
}

# Public route table (shared) and association to all public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id # Route table vẫn phụ thuộc vào IGW
  }
  tags = { Name = "${var.name}-rt-public" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private route tables (one per AZ) -> route to NAT in same AZ
resource "aws_route_table" "private" {
  for_each = toset(var.azs)
  vpc_id   = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }
  tags = { Name = "${var.name}-rt-private-${each.key}" }
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.value.availability_zone].id
}

# --- VPC Endpoints cho AWS Systems Manager (SSM) ---
resource "aws_security_group" "vpc_endpoints_sg" {
  name   = "${var.name}-vpc-endpoints-sg"
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name}-vpc-endpoints-sg" }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_vpc_endpoint" "ssm_endpoints" {
  for_each = toset([
    "ssm",
    "ssmmessages",
    "ec2messages"
  ])
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [for s in aws_subnet.private : s.id]
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  tags                = { Name = "${var.name}-${each.key}-endpoint" }
}

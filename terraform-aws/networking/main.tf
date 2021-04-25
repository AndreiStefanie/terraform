data "aws_availability_zones" "tf_azs" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf_vpc-${random_integer.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(local.azs, count.index)

  tags = {
    Name = "tf_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "tf_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.tf_public_rt.id
}

resource "aws_subnet" "private" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = element(local.azs, count.index)

  tags = {
    Name = "tf_private_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.tf_public_rt.id
  destination_cidr_block = local.any_ip
  gateway_id             = aws_internet_gateway.tf_igw.id
}

resource "aws_default_route_table" "tf_private_rt" {
  default_route_table_id = aws_vpc.tf_vpc.default_route_table_id

  tags = {
    Name = "tf_private"
  }
}

resource "aws_security_group" "this" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.tf_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.any_ip]
  }
}

resource "aws_db_subnet_group" "tf_rds_sng" {
  count      = var.add_db_sng ? 1 : 0
  name       = "tf_rds_subnetgroup"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "tf_rds_sng"
  }
}

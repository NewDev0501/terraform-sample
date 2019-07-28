# Declare the data source
data "aws_availability_zones" "available" {}


# Define a vpc
resource "aws_vpc" "vpc" {
  cidr_block = "${var.network_cidr}"
  tags = {
    Name = "${var.vpc}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "test_ig" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "swam_ig"
  }
}

# Public subnet 1
resource "aws_subnet" "test_public_sn_01" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_01_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "public_sn_01"
  }
}

# Public subnet 2
resource "aws_subnet" "test_public_sn_02" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public_02_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "public_sn_02"
  }
}

# Routing table for public subnet 1
resource "aws_route_table" "test_public_sn_rt_01" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_ig.id}"
  }
  tags = {
    Name = "public_sn_rt_01"
  }
}

# Associate the routing table to public subnet 1
resource "aws_route_table_association" "test_public_sn_rt_01_assn" {
  subnet_id = "${aws_subnet.test_public_sn_01.id}"
  route_table_id = "${aws_route_table.test_public_sn_rt_01.id}"
}

# Routing table for public subnet 2
resource "aws_route_table" "test_public_sn_rt_02" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_ig.id}"
  }
  tags = {
    Name = "public_sn_rt_02"
  }
}

# Associate the routing table to public subnet 2
resource "aws_route_table_association" "test_public_sn_rt_assn_02" {
  subnet_id = "${aws_subnet.test_public_sn_02.id}"
  route_table_id = "${aws_route_table.test_public_sn_rt_02.id}"
}

# ECS Instance Security group
resource "aws_security_group" "test_public_sg" {
  name = "public_sg"
  description = "Test public access security group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [
      "${var.public_01_cidr}",
      "${var.public_02_cidr}"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "test_public_sg"
  }
}

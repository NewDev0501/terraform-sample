provider "aws" {
  profile = "default"
  region  = "${var.region}"
}


# Define a vpc
resource "aws_vpc" "vpc_name" {
  cidr_block = "${var.vpc_cidr_block}"
  tags = {
    Name = "${var.vpc_name}"
  }
}



# Internet gateway for the public subnet
resource "aws_internet_gateway" "demo_ig" {
  vpc_id = "${aws_vpc.vpc_name.id}"
  tags = {
    Name = "demo_ig"
  }
}

# Public subnet
resource "aws_subnet" "vpc_public_sn" {
  vpc_id     = "${aws_vpc.vpc_name.id}"
  cidr_block = "${var.vpc_public_subnet_1_cidr}"
  # availability_zone = "${lookup(var.availability_zone, var.vpc_region)}"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "vpc_public_sn"
  }
}

# Private subnet
resource "aws_subnet" "vpc_private_sn" {
  vpc_id            = "${aws_vpc.vpc_name.id}"
  cidr_block        = "${var.vpc_private_subnet_1_cidr}"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "vpc_private_sn"
  }
}

# Routing table for public subnet
resource "aws_route_table" "vpc_public_sn_rt" {
  vpc_id = "${aws_vpc.vpc_name.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo_ig.id}"
  }
  tags = {
    Name = "vpc_public_sn_rt"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "vpc_public_sn_rt_assn" {
  subnet_id      = "${aws_subnet.vpc_public_sn.id}"
  route_table_id = "${aws_route_table.vpc_public_sn_rt.id}"
}

#Associate a new EC2 instance with VPC
resource "aws_instance" "ec2" {
  ami                         = "ami-0b898040803850657"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.vpc_public_sn.id}"
  associate_public_ip_address = "true"
}

# ECS Instance Security group
resource "aws_security_group" "vpc_public_sg" {
  name        = "demo_pubic_sg"
  description = "demo public access security group"
  vpc_id      = "${aws_vpc.vpc_name.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "${var.vpc_access_from_ip_range}"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    cidr_blocks = [
    "${var.vpc_public_subnet_1_cidr}"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    Name = "demo_pubic_sg"
  }
}

resource "aws_security_group" "vpc_private_sg" {
  name        = "demo_private_sg"
  description = "demo security group to access private ports"
  vpc_id      = "${aws_vpc.vpc_name.id}"

  # allow memcached port within VPC
  ingress {
    from_port = 11211
    to_port   = 11211
    protocol  = "tcp"
    cidr_blocks = [
    "${var.vpc_public_subnet_1_cidr}"]
  }

  # allow redis port within VPC
  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    cidr_blocks = [
    "${var.vpc_public_subnet_1_cidr}"]
  }

  # allow postgres port within VPC
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
    "${var.vpc_public_subnet_1_cidr}"]
  }

  # allow mysql port within VPC
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [
    "${var.vpc_public_subnet_1_cidr}"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    Name = "demo_private_sg"
  }
}

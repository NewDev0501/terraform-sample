provider "aws" {
  profile    = "default"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-0b898040803850657"
  instance_type = "t2.micro"
}

resource "aws_vpc_peering_connection" "vpc-0d04ce1ec29cb411a" {
  vpc_id        = "vpc-0d04ce1ec29cb411a"
}
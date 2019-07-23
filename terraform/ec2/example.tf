provider "aws" {
  profile = "default"
  region  = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-3f36be41"
  instance_type = "t3.micro"
}

# resource "aws_vpc_peering_connection" "vpc-0d04ce1ec29cb411a" {
#   peer_owner_id = "${var.peer_owner_id}"
#   peer_vpc_id   = "${aws_vpc.bar.id}"
#   vpc_id        = "vpc-0d04ce1ec29cb411a"
# }

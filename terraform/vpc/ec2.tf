
#Associate a new EC2 instance with VPC
# ami                         = "ami-0b898040803850657" -- for us-east-1 region
resource "aws_instance" "ec2-01" {
  ami                         = "ami-4bd45f35"
  instance_type               = "t3.micro"
  subnet_id                   = "${aws_subnet.vpc_public_sn.id}"
  security_groups             = ["${aws_security_group.vpc_public_sg}"]
  associate_public_ip_address = "true"
  user_data                   = "${file("userdata.sh")}"
}


resource "aws_instance" "ec2-02" {
  ami                         = "ami-4bd45f35"
  instance_type               = "t3.micro"
  subnet_id                   = "${aws_subnet.vpc_public_sn.id}"
  security_groups             = ["${aws_security_group.vpc_public_sg}"]
  associate_public_ip_address = "true"
  user_data                   = "${file("userdata.sh")}"
}

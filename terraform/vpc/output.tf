output "VPC_ID" {
  value = "${aws_vpc.vpc_name.id}"
}

output "EC2_01_public_ip" {
  value = "${aws_instance.ec2-01.public_ip}"
}

output "EC2_01_private_ip" {
  value = "${aws_instance.ec2-01.private_ip}"
}


output "EC2_02_public_ip" {
  value = "${aws_instance.ec2-02.public_ip}"
}

output "EC2_02_private_ip" {
  value = "${aws_instance.ec2-02.private_ip}"
}
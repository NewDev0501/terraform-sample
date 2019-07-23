output "VPC_ID" {
  value = "${aws_vpc.vpc_name.id}"
}

output "EC2_public_ip" {
  value = "${aws_instance.ec2.public_ip}"
}

output "EC2_private_ip" {
  value = "${aws_instance.ec2.private_ip}"
}
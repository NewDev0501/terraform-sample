output "VPC_ID" {
  value = "${aws_vpc.vpc_name.id}"
}

/*output "EC2_private_ip" {
  value = "${aws_instance.example.private_ip}"
}*/
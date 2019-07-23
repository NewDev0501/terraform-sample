output "EC2_public_ip" {
  value = "${aws_instance.example.public_ip}"
}

output "EC2_private_ip" {
  value = "${aws_instance.example.private_ip}"
}
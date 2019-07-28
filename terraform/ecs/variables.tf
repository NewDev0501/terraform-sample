# main creds for AWS connection
variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "ecs_key_pair_name" {
  description = "ECS key pair name"
}

variable "region" {
  description = "AWS region"
}

variable "availability_zone" {
  description = "availability zone used for the demo, based on region"
  default = {
    us-east-1 = "us-east-1"
  }
}

# Networks

variable "vpc" {
  description = "VPC for Test environment"
}

variable "network_cidr" {
  description = "IP addressing for Test Network"
}

variable "public_01_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

variable "public_02_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

# Autoscaling

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}

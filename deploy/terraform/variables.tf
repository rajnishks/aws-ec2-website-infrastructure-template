variable "aws_profile" {
    description = "AWS profile to be used"
}

variable "aws_region" {
    description = "AWS region to be used"
}

variable "environment_name" {
    description = "Name of the application"
    default = "TestApp"
}

variable "main_vpc_cidr" {
    description = "CIDR of the VPC"
}

variable "public_subnet_cidrs" { 
    description = "CIDR block of the public subnets"
    type = list
}

variable "private_subnet_cidrs" { 
    description = "CIDR block of the private subnets"
    type = list
}

variable "availability_zones" {
    description = "Availability zones of the VPC"
    type = list
}

variable "instance_type" {
    description = "Which instance type should we use to build the cluster?"
    default = "t2.micro"
}

variable "build_number" {
    description = "Which version should we deploy?"
}

variable "min_cluster_size" {
    description = "How many minimum EC2 hosts do you want to initially deploy?"
}

variable "max_cluster_size" {
    description = "How many maximum EC2 hosts do you want to initially deploy?"
}

variable "ec2_ami" {
    description = "ami id for ec2 instance"
    default = ""
}

variable "operator_email" {
    description = "EMail address to notify if there are any scaling operations"
}

variable "bucket_name" {
    description = "S3 bucket name where the application version artifacts are stored."
}
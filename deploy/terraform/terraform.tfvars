aws_profile = "la"
aws_region = "us-east-1"

main_vpc_cidr = "10.0.0.0/16"
environment_name = "SampleWebApp"

#subnet mappings#
public_subnet_cidrs = ["10.0.1.0/28","10.0.2.0/28"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

#availability zones#
availability_zones = ["us-east-1a","us-east-1b"]

#application specific detaisl#
instance_type = "t2.micro"
bucket_name="s3-sample-web-app-bucket2020"
build_number="1.0.0-230520201612"
max_cluster_size=4
min_cluster_size=1
operator_email="awstestmail@yopmail.com"

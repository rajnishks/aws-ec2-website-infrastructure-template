# Create the Load Balancer Security Group
resource "aws_security_group" "LoadBalancerSecurityGroup" {
    vpc_id       = aws_vpc.vpc.id

    # allow ingress of port 80
    ingress {
        cidr_blocks = ["0.0.0.0/0"]  
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    # allow egress on all ports
    egress {
        cidr_blocks = ["0.0.0.0/0"]  
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    tags = {
        Name = "${var.environment_name}-LoadBalancersSG"
    }

}

# Create the EC2 Security Group
resource "aws_security_group" "EC2HostSecurityGroup" {
    vpc_id       = aws_vpc.vpc.id

    # allow ingress of port 22
    ingress {
        cidr_blocks = aws_vpc.vpc.cidr_block
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    # allow egress on all ports
    egress {
        cidr_blocks = ["0.0.0.0/0"]  
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    tags = {
        Name = "${var.environment_name}-EC2HostsSG"
    }

}
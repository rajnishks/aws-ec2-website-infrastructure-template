resource "aws_ami_copy" "amazon-linux-2-encrypted" {
  name              = "${data.aws_ami.amazon-linux-2.name}-encrypted"
  description       = "${data.aws_ami.amazon-linux-2.description} (encrypted)"
  source_ami_id     = data.aws_ami.amazon-linux-2.id
  source_ami_region = var.aws_region
  encrypted         = true

  tags = {
    ImageType      = "encrypted-amzn2-linux"
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

#resource "aws_instance" "ec2_instance" {
#  ...
#}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy" "ec2_log_policy" {
  name        = "ec2-instance-policy"
  description = "EC2 instance policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:Create*",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "ec2-instance-s3-policy"
  description = "EC2 instance S3 policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::*"
    }
  ]
}
EOF
}

resource "aws_alb" "app_alb" {
  name = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.LoadBalancerSecurityGroup.id]
  subnets            = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.environment_name} Load Balancer"
  }
}

resource "aws_alb_listener" "my-alb-listener" {
  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    type = "forward"
  }
  load_balancer_arn = aws_alb.app_alb.arn
  port = 80
  protocol = "HTTP"
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"  
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path = "/"
    healthy_threshold = 3
    unhealthy_threshold = 5
    timeout = 5
    interval = 30
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_autoscaling_group" "web_server_group" {
  name                      = "web_server_group"
  max_size                  = var.max_cluster_size
  min_size                  = var.min_cluster_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_configuration      = aws_launch_configuration.launch_config.name
  vpc_zone_identifier       = [aws_subnet.priv_subnet_1.id, aws_subnet.priv_subnet_2.id]
  target_group_arns         = [aws_lb_target_group.alb_target_group.arn]
  termination_policies      = ["OldestInstance", "OldestLaunchConfiguration"]

  timeouts {
    delete = "15m"
  }

}

resource "aws_autoscaling_notification" "web_server_notifications" {
  group_names = [
    aws_autoscaling_group.web_server_group.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.asg_notification_topic.arn
}

resource "aws_sns_topic" "asg_notification_topic" {
  name = "asg-notification-topic"
}

resource "aws_launch_configuration" "launch_config" {
  name_prefix             = "ec2-launch-config"
  image_id                = (length(var.ec2_ami) > 0 ? var.ec2_ami : data.aws_ami.amazon-linux-2.id)
  instance_type           = var.instance_type
  security_groups         = [aws_security_group.EC2HostSecurityGroup.id]
  iam_instance_profile    = aws_iam_instance_profile.ec2_instance_profile.id
  user_data               = templatefile("./userdata.tmpl", 
                                    {
                                      aws_region = var.aws_region, 
                                      stack_name = var.environment_name, 
                                      app_version = var.build_number,
                                      bucket_name = var.bucket_name
                                    })

  lifecycle {
    create_before_destroy = true
  }
}
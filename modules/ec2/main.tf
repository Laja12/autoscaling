# modules/ec2/main.tf
resource "aws_launch_template" "web" {
  name_prefix = "web-template"
  image_id = "ami-0e35ddab05955cf57" # Replace with latest Amazon Linux 2 AMI
  instance_type = "t3.micro"
  user_data = base64encode(file("user_data.sh"))
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity = 2
  max_size = 5
  min_size = 1
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id = aws_launch_template.web.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.web_tg.arn]
  health_check_type = "EC2"
}

resource "aws_lb_target_group" "web_tg" {
  name = "web-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

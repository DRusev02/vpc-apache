resource "aws_launch_template" "web_server_lt" {
  name = "dimitar-launch-template"

  iam_instance_profile {
    name = "ssm-role"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 50
    }
  }

  image_id               = "ami-0b610602df05e8fd0"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  key_name               = "bastion-key-pair"
  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    aws s3 cp s3://dimitar-s3-bucket/index.html /var/www/html/index.html --region eu-south-1
    EOF
  )
}







resource "aws_autoscaling_group" "web_server_asg" {
  name             = "web-server-asg"
  min_size         = 0
  max_size         = 1
  desired_capacity = 1
  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.private-1.id]
  target_group_arns   = [aws_lb_target_group.web_target_group.arn]
  depends_on          = [aws_nat_gateway.nat_gateway]
}




resource "aws_lb" "web_alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  security_groups    = [aws_security_group.alb_security_group.id]

}



resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id


}






resource "aws_iam_role" "listener_role" {
  name = "listener-role-dimitar"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "elasticloadbalancing.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "listener_policy_attachment" {
  name       = "listener-policy-attachment"
  roles      = [aws_iam_role.listener_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}
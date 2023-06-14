resource "aws_lb_target_group" "ecommerce_tg" {
  name     = "EcommerceTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecommerce_vpc.id

  health_check {
    path        = "/"
    port        = "traffic-port"
    protocol    = "HTTP"
    interval    = 30
    timeout     = 10
    unhealthy_threshold = 2
    healthy_threshold = 2
  }

  tags = {
    Name = "EcommerceTargetGroup"
  }
}

resource "aws_lb_target_group_attachment" "ecommerce_tg" {
  target_group_arn = aws_lb_target_group.ecommerce_tg.arn
  target_id        = aws_instance.apache_server.id
  port             = 80
}

resource "aws_lb" "ecommerce_lb" {
  name               = "EcommerceALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecommerce_sg.id]
  subnets            = [aws_subnet.public_subnet.id]

  tags = {
    Name = "ExampleALB"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecommerce_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecommerce_tg.arn
  }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecommerce_lb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecommerce_tg.arn
  }

  ssl_policy = "ELBSecurityPolicy-2016-08"
}

resource "aws_lb_listener_certificate" "example" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate.ecommerce_cert.arn
}
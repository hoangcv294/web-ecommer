#######################-Create Target Group-#######################
resource "aws_lb_target_group" "ecommerce_tg" {
  name     = "${var.project}-TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecommerce_vpc.id

  health_check {
    path                = "/html"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 4
    interval            = 10
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project}-TargetGroup"
  }
}

#######################-Create Target Group Instance-#######################
resource "aws_lb_target_group_attachment" "ecommerce_tg" {
  target_group_arn = aws_lb_target_group.ecommerce_tg.arn
  target_id        = aws_instance.apache_server.id
  port             = 80
}

#######################-Create ALB-#######################
resource "aws_lb" "ecommerce_lb" {
  name               = "${var.project}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecommerce_sg.id]
  subnets            = tolist([aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id])

  tags = {
    Name = "${var.project}-ALB"
  }
}

#######################-Create listener HTTP-#######################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecommerce_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecommerce_tg.arn
  }
}

#######################-Create listener cert-#######################
resource "aws_lb_listener_certificate" "listener_cert" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = data.aws_acm_certificate.ecommerce_cert.arn
}

#######################-Create listener HTTPS-#######################
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecommerce_lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.ecommerce_cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecommerce_tg.arn
  }

  ssl_policy = "ELBSecurityPolicy-2016-08"
}

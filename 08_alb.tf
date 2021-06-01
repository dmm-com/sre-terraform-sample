
resource "aws_lb" "web" {
  name                       = "alb"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = data.aws_subnet_ids.public.ids
  enable_deletion_protection = false # 本番用途であれば誤って消えないようにtrueを推奨
  enable_http2               = true
  idle_timeout               = "60"
  internal                   = false
  ip_address_type            = "ipv4"
}

resource "aws_lb_target_group" "ec2_web" {
  name   = "ec2-web"
  vpc_id = data.aws_vpc.vpc.id

  target_type = "instance"
  port        = "80"
  protocol    = "HTTP"

  health_check {
    enabled             = true
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

}

resource "aws_lb_target_group_attachment" "ec2_web" {
  count            = length(aws_instance.ec2_web)
  target_group_arn = aws_lb_target_group.ec2_web.arn
  target_id        = element(aws_instance.ec2_web, count.index).id
  port             = 80
}


resource "aws_lb_listener" "web_80" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"
  # 実際には正規のURL（例：www.dmm.com/**など）以外のアクセスはブロックするが今回は省略
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_web.arn
  }
}

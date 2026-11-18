
# Security Group
resource "aws_security_group" "alb" {
  name        = "${var.name}-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnet_ids

}

# NGINX Target Group
resource "aws_lb_target_group" "nginx" {
  name        = "nginx-targets"
  port        = var.nginx_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"  # 這邊選擇target type 為 IP 連接 k3s agent node

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

}

# Envoy Target Group
resource "aws_lb_target_group" "envoy" {
  name        = "envoy-targets"
  port        = var.envoy_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"  # 這邊選擇target type 為 IP 連接 k3s agent node

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No matching host"
      status_code  = "404"
    }
  }
}

# NGINX Host Rule
resource "aws_lb_listener_rule" "nginx" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  condition {
    host_header {
      values = ["app.local.test"]
    }
  }
}

# Envoy Host Rule
resource "aws_lb_listener_rule" "envoy" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.envoy.arn
  }

  condition {
    host_header {
      values = ["api.local.test"]
    }
  }
}
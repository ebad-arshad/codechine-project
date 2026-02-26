resource "aws_lb" "alb" {
  name            = "alb-${terraform.workspace}"
  load_balancer_type = "application"
  security_groups = [var.alb_sg.id]
  subnets         = [for subnet in var.public_subnet : subnet.id]

  tags = {
    Name        = "ALB-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# 1. Target Group for the Frontend
resource "aws_lb_target_group" "frontend_tg" {
  name     = "Frontend-tg-${terraform.workspace}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc.id

  health_check {
    path    = "/"
    port    = "80"
    matcher = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "frontend_attach" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.frontend_instance.id
  port             = 80
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Send traffic to the Backend Ecommerce App
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }

  tags = {
    Name        = "HTTP-Listener-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
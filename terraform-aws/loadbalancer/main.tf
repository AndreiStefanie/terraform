resource "aws_alb" "this" {
  name            = "tf-loadbalancer"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400
}

resource "aws_alb_target_group" "this" {
  name     = "tf-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
    interval            = var.interval
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = var.listener_port
  protocol          = var.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
}

module "alb" {
  depends_on = [
    aws_vpc.main
  ]
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name               = "Terraform-Jenkins-ALB"
  load_balancer_type = "application"
  vpc_id             = aws_vpc.main.id
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  security_groups    = [aws_security_group.ALB-SG.id]

  target_groups = [
    {
      name             = "Terraform-ALB-TG"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "HTTP"
    }
  ]
}
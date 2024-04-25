resource "aws_launch_configuration" "app" {
  name            = "app-config"
  image_id        = "ami-04e5276ebb8451442"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2_sg.id]
}

resource "aws_elb" "web" {
  name       = "web-elb"
  subnets    = aws_subnet.public.*.id
  security_groups = [aws_security_group.elb_sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
}

resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.name
  min_size             = 1
  max_size             = 10
  vpc_zone_identifier  = aws_subnet.public.*.id
  load_balancers       = [aws_elb.web.id]
}
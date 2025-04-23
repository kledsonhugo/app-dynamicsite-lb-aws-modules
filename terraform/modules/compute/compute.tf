resource "aws_security_group" "vpc_sg_pub" {
  vpc_id = var.vpc_id
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "vpc_sg_pub"
  }
}

data "template_file" "user_data" {
  template = file("./modules/compute/scripts/user_data.sh")
}

resource "aws_instance" "instance-a" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_az1a_id
  vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
  user_data              = base64encode(data.template_file.user_data.rendered)
  tags = {
    Name = "instance-a"
  }
}

resource "aws_instance" "instance-b" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_az1b_id
  vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
  user_data              = base64encode(data.template_file.user_data.rendered)
  tags = {
    Name = "instance-b"
  }
}

resource "aws_lb_target_group" "ec2_lb_tg" {
  name     = "ec2-lb-tg"
  protocol = "HTTP"
  port     = "80"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_lb_tg-instance_a" {
  target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  target_id        = aws_instance.instance-a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2_lb_tg-instance_b" {
  target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  target_id        = aws_instance.instance-b.id
  port             = 80
}

resource "aws_lb" "ec2_lb" {
  name               = "ec2-lb"
  load_balancer_type = "application"
  subnets            = [var.subnet_az1a_id, var.subnet_az1b_id]
  security_groups    = [aws_security_group.vpc_sg_pub.id]
}

resource "aws_lb_listener" "ec2_lb_listener" {
  protocol          = "HTTP"
  port              = "80"
  load_balancer_arn = aws_lb.ec2_lb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  }
}
variable "elb_port" {
  type = string
  default = 80
}

# By default traffic is not allowed for a load balancer. That is why you have to define a security group.
resource "aws_security_group" "elb" {

  name = "terraform-example-elb"  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "example" {

  name               = "terraform-asg-example"
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}

data "aws_availability_zones" "all" {}

output load_balancer_name {
    value = aws_elb.example.name
    description = "The load balancer"
}

output instructions {
    value = join("", ["To test run: ", "curl http://", aws_elb.example.dns_name])
    description = "Instructions to test service"
}
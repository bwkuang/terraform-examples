resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names
  load_balancers = [var.load_balancer_name]

  min_size = 2
  max_size = 3

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  lifecycle {
    create_before_destroy = true # If false aws destroys the resource first
  }     
}

variable "server_port" {
    type = string
    default = 8080
}

resource "aws_security_group" "instance" {
  name = "terraform-security-group-instance"

  ingress {
    to_port = var.server_port
    from_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
}

data "aws_availability_zones" "all" {}

output server_port {
    value = var.server_port
    description = "The port the servers listen to"
}


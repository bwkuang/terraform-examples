provider "aws" {
  region = "us-east-2"
}

module "asg_example" {
  source = "./modules/autoscaling-group"
  load_balancer_name = module.load_balancer.load_balancer_name
}

module "load_balancer" {
  source = "./modules/load-balancer"
  server_port = module.asg_example.server_port
}

output "instructions" {
  value = module.load_balancer.instructions
}
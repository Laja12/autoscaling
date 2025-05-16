provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-vamsee"
    key            = "terraform/autoscaling/statefile"
    region         = "us-west-1"
    encrypt        = true
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  security_group_id = module.vpc.security_group_id
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  target_group_arn = module.ec2.target_group_arn
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  asg_name = module.ec2.asg_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
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

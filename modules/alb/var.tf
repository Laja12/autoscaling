variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group for the ALB listener"
  type        = string
}

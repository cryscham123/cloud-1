variable "AWS_REGION" {
  type        = string
  description = "The region in which AWS resources will be created"
}

variable "SSH_CIDR_BLOCKS" {
  description = "CIDR blocks for SSH access"
  type        = list(string)
}

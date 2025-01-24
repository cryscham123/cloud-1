variable "AWS_REGION" {
  type        = string
  description = "The region in which AWS resources will be created"
}

variable "SERVER_INSTANCE_COUNT" {
  description = "Number of server instances"
  type        = number
}

variable "SSH_PUBLIC_KEY_PATH" {
  description = "Path for SSH public key"
  type        = string
}

variable "SSH_IP" {
  description = "IP for SSH access"
  type        = string
}

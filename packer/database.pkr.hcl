packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
    amazon = {
      version = ">= 1.2.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "AWS_REGION" {
  type = string
}

variable "MYSQL_USER" {
  type = string
}

variable "MYSQL_PASSWORD" {
  type = string
}

variable "DATABASE_NAME" {
  type = string
}

variable "MYSQL_ROOT_PASSWORD" {
  type = string
}

source "amazon-ebs" "database" {
  region  = var.AWS_REGION
  profile = "default"

  ami_name      = "hyunghki-database-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  instance_type = "t2.micro"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.database"]

  provisioner "ansible" {
    playbook_file = "${path.root}/ansible/database.yml"
    user = "ubuntu"
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "MYSQL_USER=${var.MYSQL_USER}",
      "MYSQL_PASSWORD=${var.MYSQL_PASSWORD}",
      "DATABASE_NAME=${var.DATABASE_NAME}",
      "MYSQL_ROOT_PASSWORD=${var.MYSQL_ROOT_PASSWORD}",
      "ANSIBLE_PYTHON_INTERPRETER=auto_silent"
    ]
  }
}

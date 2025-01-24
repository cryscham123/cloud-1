resource "aws_key_pair" "my_labtop" {
  key_name   = "my_labtop"
  public_key = file(var.SSH_PUBLIC_KEY_PATH)
}

module "network" {
  source = "../modules/network"

  AWS_REGION           = var.AWS_REGION
  SSH_CIDR_BLOCKS      = ["${var.SSH_IP}/32"]
}

resource "aws_instance" "server" {
  count         = var.SERVER_INSTANCE_COUNT
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [module.network.server_sg_id]
  subnet_id              = module.network.public_subnets[count.index % 2]

  key_name = aws_key_pair.my_labtop.key_name
  tags = {
    Name = "serverNode"
  }
}

resource "aws_instance" "database" {
  count         = var.SERVER_INSTANCE_COUNT
  ami           = data.aws_ami.database_ami.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [module.network.database_sg_id]
  subnet_id              = module.network.private_subnets

  key_name = aws_key_pair.my_labtop.key_name
  tags = {
    Name = "dbNode"
  }
}

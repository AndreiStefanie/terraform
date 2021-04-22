data "aws_ami" "server" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_id" "node_id" {
  count = var.instance_count

  byte_length = 2
}

resource "aws_instance" "node" {
  count = var.instance_count

  instance_type          = var.instance_type
  ami                    = data.aws_ami.server.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = element(var.public_subnets, count.index)

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = "tf-node-${random_id.node_id[count.index].dec}"
  }
}

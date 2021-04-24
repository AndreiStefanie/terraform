data "aws_ami" "server" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_id" "this" {
  count = var.instance_count

  byte_length = 2
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "node" {
  count = var.instance_count

  instance_type          = var.instance_type
  ami                    = data.aws_ami.server.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = element(var.public_subnets, count.index)
  key_name               = aws_key_pair.this.id
  user_data = templatefile(var.user_data_path,
    {
      nodename    = "tf-node-${random_id.this[count.index].dec}"
      db_user     = var.db_user
      db_pass     = var.db_pass
      db_endpoint = var.db_endpoint
      db_name     = var.db_name
    }
  )

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = "tf-node-${random_id.this[count.index].dec}"
  }
}

resource "aws_alb_target_group_attachment" "this" {
  count = var.instance_count

  target_group_arn = var.target_group_arn
  target_id        = aws_instance.node[count.index].id
  port             = 8080
}

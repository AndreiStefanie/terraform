//--------------------------------------------------------------------
// Variables



//--------------------------------------------------------------------
// Modules
module "compute" {
  source  = "app.terraform.io/clover-tech/compute/aws"
  version = "1.0.1"

  aws_region          = "eu-west-1"
  public_key_material = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZSZ0ec7aMHJG0jDNmYSOyAhLf9WLulIy7E4usA9VvjCZ7wqpRdUq6qLYbKLholRwnnw87KZp3U2l7cpSbqYOt07VcOBtBkKy5ViiuT7Psd2pJXue82KROqo03AR2m1A5WqMh8QY6AX/wMbg2CZwElyoMkVRDuW+9AGThJGZ5Z4VAWaAoRMud8FCiH++SVhQcfPNVfkhWK0/Z8DcW3yhVmEZ+KTYiycubqkmvjb4hq2354BxmgZJwF+fu688jft1/3avUi2Q21ML5O4zCcdImT+bPxQC0+jX2+vncqXPd7S0RAwdhQY8flRshjlhCA/dDWIRrxvIIGA4cvdBJ/7EmCtRZ/rg5dosoh/17A8Ur4ZFdDMxEtnNKrlbitTjYd2hHjhK9wIxIy0eObKH7ag4EBC1fqGWMO5K/sOhNfh713sg1vsr9JUrP9OT0IyKgvjs6cm/XW55qC7dQUY8JA34cFAeDxVBMVdCiQ9+tcsEiqS6YRhSZmAc3Pxz26K/OrUjk= andrei@Ideapad"
  security_group      = module.networking.public_sg
  subnets             = module.networking.public_subnets
}

module "networking" {
  source  = "app.terraform.io/clover-tech/networking/aws"
  version = "1.0.2"

  access_ip  = "0.0.0.0/0"
  aws_region = "eu-west-1"
}

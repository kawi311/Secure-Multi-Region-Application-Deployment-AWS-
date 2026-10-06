data "terraform_remote_state" "region_a" {
  backend = "local"

  config = {
    path = "../region-a/terraform.tfstate"
  }
}

data "terraform_remote_state" "region_z" {
  backend = "local"

  config = {
    path = "../region-z/terraform.tfstate"
  }
}

resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = {
    ManagedBy = "terraform-global"
  }
}

module "dns_failover" {
  source = "../modules/dns"

  hosted_zone_id = aws_route53_zone.this.zone_id
  record_name    = var.record_name

  primary_alb_dns_name = data.terraform_remote_state.region_a.outputs.alb_dns_name
  primary_alb_zone_id  = data.terraform_remote_state.region_a.outputs.alb_zone_id

  secondary_alb_dns_name = data.terraform_remote_state.region_z.outputs.alb_dns_name
  secondary_alb_zone_id  = data.terraform_remote_state.region_z.outputs.alb_zone_id
}

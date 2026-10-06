data "aws_ssm_parameter" "amzn2" {
  count = var.ami == "" && var.os != "windows" ? 1 : 0
  name  = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "windows2019" {
  count = var.ami == "" && var.os == "windows" ? 1 : 0
  name  = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-Base"
}

locals {
  resolved_ami = var.ami != "" ? var.ami : (var.os == "windows" ? (length(data.aws_ssm_parameter.windows2019) > 0 ? data.aws_ssm_parameter.windows2019[0].value : "") : (length(data.aws_ssm_parameter.amzn2) > 0 ? data.aws_ssm_parameter.amzn2[0].value : ""))
}

resource "aws_instance" "this" {
  count = length(var.private_subnet_ids)

  ami                    = local.resolved_ami
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name != "" ? var.key_name : null
  user_data_base64       = var.user_data_base64

  tags = merge({ Name = "${var.name}-${replace(var.private_subnet_ids[count.index], "-", "_")}" }, var.tags)
}

resource "aws_iam_role" "instance" {
  count = var.create_iam_instance_profile ? 1 : 0

  name = "${var.name}-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_iam_instance_profile ? 1 : 0
  name  = var.iam_instance_profile_name != "" ? var.iam_instance_profile_name : "${var.name}-instance-profile"
  role  = aws_iam_role.instance[0].name
}

resource "aws_launch_template" "lt" {
  name_prefix = "${var.name}-lt-"
  # Resolve AMI per-region; var.ami can override if provided
  image_id      = local.resolved_ami
  instance_type = var.instance_type

  iam_instance_profile {
    # Ưu tiên sử dụng ARN nếu được cung cấp, nếu không thì dùng name của profile được tạo trong module.
    arn = var.iam_instance_profile_arn != "" ? var.iam_instance_profile_arn : (var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].arn : null)
  }

  user_data = var.user_data_base64

  network_interfaces {
    security_groups = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge({ Name = var.name }, var.tags)
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = "${var.name}-asg-"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids
  force_delete        = true 

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  target_group_arns = var.target_group_arn != "" ? [var.target_group_arn] : []
}

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${var.name}-cpu-target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

// Use SSM parameters instead of DescribeImages (avoids ec2:DescribeImages requirement)
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

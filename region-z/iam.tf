# Tạo IAM Role cho phép EC2 được quản lý bởi các dịch vụ AWS
resource "aws_iam_role" "ec2_instance_role" {
  name = "${module.region-z.name}-ec2-instance-role"

  # Chính sách tin cậy, cho phép dịch vụ EC2 "assume" (đảm nhận) role này
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Gắn policy được quản lý bởi AWS để cho phép SSM hoạt động
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Tạo Instance Profile để gắn Role vào EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${module.region-z.name}-ec2-profile"
  role = aws_iam_role.ec2_instance_role.name
}

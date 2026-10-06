# ===================================================================
# --- PUBLIC SUBNET (ALB, NAT GATEWAY) ---
# ===================================================================

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-public-nacls"
  }
}

# --- PUBLIC INBOUND (ĐI VÀO) ---

resource "aws_network_acl_rule" "public_ingress_deny_bad_ip" {
  count          = var.block_cidr != "" ? 1 : 0
  network_acl_id = aws_network_acl.public.id
  rule_number    = 50
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = var.block_cidr
}

resource "aws_network_acl_rule" "public_ingress_allow_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_ingress_allow_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_ingress_allow_ssh" {
  count = var.admin_cidr != "" ? 1 : 0
  # ... (Giữ nguyên code của bạn)
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.admin_cidr
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_ingress_allow_ephemeral_alb" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 140
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_ingress_allow_ephemeral_nat_return" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 150
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# --- PUBLIC OUTBOUND (ĐI RA) ---
resource "aws_network_acl_rule" "public_egress_allow_all" {
  network_acl_id = aws_network_acl.public.id
  egress         = true
  rule_number    = 200
  cidr_block     = "0.0.0.0/0"
  protocol       = "-1"
  rule_action    = "allow"
}

# --- PUBLIC ASSOCIATION ---
resource "aws_network_acl_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.public.id
}

# ===================================================================
# --- PRIVATE SUBNET (EC2 & RDS) ---
# ===================================================================

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-private-nacls"
  }
}

# --- PRIVATE INBOUND (ĐI VÀO) ---
resource "aws_network_acl_rule" "private_ingress_allow_internal" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
}

resource "aws_network_acl_rule" "private_ingress_allow_ephemeral_from_internet" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110 # Phải có độ ưu tiên cao
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# --- PRIVATE OUTBOUND (ĐI RA) ---
resource "aws_network_acl_rule" "private_egress_allow_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# --- PRIVATE ASSOCIATION ---
resource "aws_network_acl_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.private.id
}

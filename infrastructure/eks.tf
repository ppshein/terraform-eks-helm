resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "${var.eks.name}-sg"
  vpc_id      = data.aws_vpc.main_vpc.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      data.aws_vpc.main_vpc.cidr_block
    ]
  }
}

resource "aws_iam_role" "node_role" {
  name = "${var.eks.name}-nodes-policy"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.node_role.name
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  manage_aws_auth = false
  cluster_name    = var.eks.name
  cluster_version = var.eks.version
  subnets         = data.aws_subnet_ids.all_subnet_ids.ids
  vpc_id          = data.aws_vpc.main_vpc.id
  workers_group_defaults = {
    root_volume_type = "gp3"
  }
  map_users     = var.eks.map_users
  map_roles     = var.eks.map_roles
  map_accounts  = var.eks.map_accounts
  enable_irsa   = true
  worker_groups = []
  tags          = local.common_tags
}

resource "aws_eks_node_group" "main" {
  cluster_name    = var.eks.name
  node_group_name = "${var.eks.name}-nodes"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnet_ids.all_subnet_ids.ids

  scaling_config {
    min_size     = var.eks.min_capacity
    desired_size = var.eks.min_capacity
    max_size     = var.eks.max_capacity
  }
  update_config {
    max_unavailable = 2
  }
  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.CloudWatchLogsFullAccess
  ]
}

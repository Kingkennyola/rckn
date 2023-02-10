# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.21"

  vpc_config {
    # Security group IDs for the EKS cluster and worker nodes. Not required as it is already applied to subnets.
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id] 
    # List of subnet IDs to use for the cluster.
    subnet_ids = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
    # Specify whether or not the Amazon EKS private API endpoint is enabled. 
    endpoint_private_access = true
    # Specify whether or not the Amazon EKS public API endpoint is enabled.
    endpoint_public_access = true
    # List of CIDR blocks that can access the EKS public endpoint.
    public_access_cidrs = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags
  )

  # Depends on the IAM Role Policy Attachment
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}
data "aws_availability_zones" "available" {
  state = "available"
}



# EKS Cluster IAM Role
resource "aws_iam_role" "cluster" {
  name = "${var.project}-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.project}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

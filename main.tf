# Configure AWS provider
provider "aws" {
  region = "us-east-1" # Update with your desired region
}

# Configure Kubernetes provider
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

# Configure Helm provider
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Subnets
resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index)
}

# Create Security Group
resource "aws_security_group" "eks_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IAM Role and Policy for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks_role"
  
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "eks_policy_attachment" {
  name       = "eks_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.eks_role.name]
}

# Create EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.private_subnet.*.id
    security_group_ids = [aws_security_group.eks_security_group.id]
  }
}

# Output EKS Cluster Endpoint and ARN
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

# S3 Bucket for uploaded CSV files
resource "aws_s3_bucket" "csv_files_bucket" {
  bucket = "csv-files-bucket" # Update with your desired bucket name
}

# S3 Bucket for Kubeflow pipeline artifacts and data
resource "aws_s3_bucket" "kubeflow_bucket" {
  bucket = "kubeflow-bucket" # Update with your desired bucket name
}

# Route 53 DNS Zone
resource "aws_route53_zone" "main_dns_zone" {
  name = "example.com" # Update with your desired domain name
}

# Create Route 53 DNS Record
resource "aws_route53_record" "kubeflow_pipeline" {
  zone_id = aws_route53_zone.main_dns_zone.zone_id
  name    = "pipeline.example.com"
  type    = "CNAME"
  ttl     = 300
  records = [module.alb.dns_name]
}

# ALB Ingress Controller
module "alb_ingress_controller" {
  source = "terraform-aws-modules/eks/aws//modules/alb-ingress-controller"

  cluster_name       = aws_eks_cluster.eks_cluster.id
  cluster_endpoint   = aws_eks_cluster.eks_cluster.endpoint
  vpc_id             = aws_vpc.main_vpc.id
  region             = "us-east-1" # Update with your desired region
  oidc_provider_arn  = aws_iam_openid_connect_provider.eks.arn
  aws_load_balancer_controller_version = "v2.2.3" # Update to the latest version
}

# Deploy the Helm chart using Terraform
resource "helm_release" "kubeflow_pipeline" {
  name       = "kubeflow-pipeline"
  repository = "https://example.com/charts" # Update with your chart repository
  chart      = "kubeflow-pipeline"
  namespace  = "kubeflow"

  set {
    name  = "image.repository"
    value = "your-docker-repo/kubeflow-pipeline"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = "pipeline.example.com"
  }

  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
  }
}
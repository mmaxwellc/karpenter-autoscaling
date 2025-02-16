locals {
    region = "us-east-2"

  # Using Existing VPC Details
    vpc_id = "vpc-0a394bf43cf55975f"
    private_subnet_ids = ["subnet-0c9af343e1b33be0c", "subnet-0bbbc5f4eac93fa7b", "subnet-0e715fe4fd86a1b24"]   
  
  # EKS Cluster Details
  name               = "dev"
  cluster_version = "1.32"  # latest
  eks_managed_node_groups = {
    dev = {
      desired_size = 2
      min_size     = 2
      max_size     = 5
      instance_types = ["t4g.large"]  # Graviton-based instance
      ami_type = "AL2_ARM_64" # Required for Graviton (Amazon Linux 2 ARM 64)    
  }  

  }
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }  

  node_security_group_tags = {
    "karpenter.sh/discovery" = "dev"
  }
}
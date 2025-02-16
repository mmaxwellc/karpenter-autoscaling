module "eks" {
  source                                    = "terraform-aws-modules/eks/aws"
  version                                   = "20.24.0"
  cluster_name                              = local.name
  cluster_version                           = local.cluster_version                 
  vpc_id                                    = local.vpc_id                          
  subnet_ids                                = local.private_subnet_ids
  eks_managed_node_groups                   = local.eks_managed_node_groups
  cluster_endpoint_public_access            = true
  enable_cluster_creator_admin_permissions  = true
  cluster_addons                            = local.cluster_addons
  node_security_group_tags                  = local.node_security_group_tags
  
}

module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  cluster_name                              = module.eks.cluster_name
  enable_v1_permissions                     = true
  enable_pod_identity                       = true
  create_pod_identity_association           = true
  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies         = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

module "karpenter-release" {
  source                                    = "../../modules/karpenter-release"
  service_account                           = module.karpenter.service_account
  cluster_name                              = module.eks.cluster_name
  cluster_endpoint                          = module.eks.cluster_endpoint
  queue_name                                = module.karpenter.queue_name
  
}

module "ec2nodeclass" {
  source                                    = "../../modules/ec2nodeclass"
  node_iam_role_name                        = module.karpenter.node_iam_role_name
  cluster_name                              = module.eks.cluster_name
  depends_on                                = [ module.karpenter-release ]
}

module "nodepool" {
  source                                    = "../../modules/nodepool"
  depends_on                                = [ module.ec2nodeclass ]
}
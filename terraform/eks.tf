module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "cloudnative-eks-prod"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  eks_managed_node_groups = {
    app_nodes = {
      name          = "eks-app-nodes"
      instance_types = ["m6i.xlarge"]
      min_size      = 3
      max_size      = 10
      desired_size  = 3
    }
  }
}

# Apply infrastructure:
#   terraform init
#   terraform validate
#   terraform apply -auto-approve
#
# Connect kubectl to the cluster:
#   aws eks update-kubeconfig --region us-east-1 --name cloudnative-eks-prod
#
# Create isolated namespaces:
#   kubectl create namespace frontend
#   kubectl create namespace backend
#   kubectl create namespace database

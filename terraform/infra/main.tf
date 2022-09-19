module "network" {
  source = "./modules/my-vpc"

  environment = "dev"
  cluster-name = var.cluster-name
  region = var.region
}

module "my-eks" {
    source = "./modules/eks-cluster"

    cluster-name = var.cluster-name
    vpc_id = module.network.vpc_id
    subnets = concat(module.network.vpc_public_subnets,  module.network.vpc_private_subnets)
}

module "airflow" {
  source                     = "./modules/airflow"
  namespace                  = "airflow"
  cluster_id                 = module.my-eks.cluster_id
  env                        = var.env
  irsa_assumable_role_arn    = module.iam_assumable_role_airflow.iam_role_arn
  dags_git_repo_url          = "git@github.com:davidfox87/dags.git"
  dags_git_repo_branch       = "master"
  chart_version              = "6.9.1"
}
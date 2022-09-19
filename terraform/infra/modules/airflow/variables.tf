variable "env" {}
variable "cluster_id" {}
variable "namespace" {
  type    = string
  default = "airflow"
}
variable "chart_version" {
  type    = string
  default = "6.9.1"
}
variable "airflow_image_tag" {}
variable "dags_git_repo_url" {}
variable "dags_git_repo_branch" {}

variable "postgres_db_name" {}
variable "postgres_db_host" {}
variable "postgres_db_username" {}

variable "irsa_assumable_role_arn" {}



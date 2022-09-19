resource "helm_release" "airflow" {
  name       = "airflow"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "airflow"
  version    = var.chart_version
  namespace  = var.namespace
  timeout    = 650

  values = [file("${path.module}/helm_values/values.yaml")]

  set {
    name  = "airflow.image.tag"
    value = var.airflow_image_tag
  }

  set {
    name  = "serviceAccount.name"
    value = var.irsa_assumable_role_arn
  }

    set {
    name  = "dags.gitSync.repo"
    value = var.dags_git_repo_url
  }

  set {
    name  = "dags.gitSync.branch"
    value = var.dags_git_repo_branch
  }
}


# load dag definitions from github
# https://github.com/airflow-helm/charts/blob/main/charts/airflow/docs/faq/dags/load-dag-definitions.md
resource "kubernetes_secret" "example" {
  metadata {
    name = "airflow-ssh-git-secret"
    namespace = "airflow"
  }

  data = {
    gitSshKey = filebase64("${path.module}/.ssh/rsa")
  }

}
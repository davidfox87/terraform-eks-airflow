locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.demo.endpoint}
    certificate-authority-data: ${aws_eks_cluster.demo.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "cluster_id" {
  value = aws_eks_cluster.demo.id
}

output "cluster_endpoint" {
    value = aws_eks_cluster.demo.endpoint
}

output "cluster_security_group_id" {
    value = aws_security_group.cluster_security_group_id.id
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}
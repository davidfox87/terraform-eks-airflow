variable "cluster-name" {
  type        = string
  description = "eks-cluster"
  default = "test-EKS-cluster"
}

variable "region" {
  description = "AWS region"
  type        = string
  default = "us-west-1"
}

variable "airflow_namespace" {
  type        = string
  default     = "airflow"
}

variable "airflow_sa_name" {
  type        = string
  default     = "airflow_sa"
}
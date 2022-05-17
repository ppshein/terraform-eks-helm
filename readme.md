# Project purpose

This project is to provision AWS EKS Cluster with fluentd logs collection. It has three folders:
**- infrastructure**
	It is to provision AWS EKS cluster with fluentd log collector with terraform. Detail information will be checked inside this folder.
	
**- dependencies**
	It is to deploy/install Nginx Ingress controller for above EKS cluster with helm. Detail information will be checked inside this folder.
	
**- application**
	It is to deploy application into above EKS cluster with Helm. Detail information will be checked inside this folder.

All components can be assumed to use inside Jenkins server or you can choose any other tools as well.

**Dependencies:**

| Key  | Value  |
| ------------ | ------------ |
| Terraform  |  v1.1.9 |
| Helm  | v3.8.2  |
| Kubectl Client Version  | v1.24.0  |
| Kustomize Version  | v4.5.4  |
| AWS  | aws-cli/2.6.4  |

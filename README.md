#  Vault Cluster Auto Unseal on K8s with AZ Key Vault

## Deploy Vault Cluster on K8s with Raft Backend using Helm Chart & Vault Auto Unseal with AZ Key Vault LLD

![alt text](./images/auto-unseal-vault-k8s-lld.png)

## Deploy Vault Auto Unseal with Azure KV LLD

![alt text](./images/akv-lld.png)

## This project highlights

- **Production ready vault cluster deployment on K8s with helm chart**
- **Using helm chart helps vault cluster deployment**
  1. Simplified Deployment and Management
  2. With official Helm chart from HashiCorp makes best practices preconfigured 
  3. Highly Configurable according to your business use cases
- **A Vault deployment on Kubernetes with Raft-based Integrated Storage ensures ***durable data persistence*** and ***synchronized state replication*** across all cluster nodes.**
- **Kubernetes-based Vault deployment supports ***high availability*** and ensures ***fault tolerance*** for resilient secret management.**
-  **Kubernetes controllers continuously monitor Vault pods and automatically recreate any that crash or are unintentionally deleted.**
- **Manual reconfiguration for Vault leader election is not required when a Vault server goes down.**
- **Integrating Automatic Unsealing with AZ Key Vault to Vault Cluster on K8s makes**
  1. ***No manual intervention to unseal the vault server if one of the vault server is restarted or updated or scaled***
  2. ***Keys are securely managed by cloud KMS, reducing risk of leakage.***
  3. ***Avoids the need to distribute unseal keys among operator.***

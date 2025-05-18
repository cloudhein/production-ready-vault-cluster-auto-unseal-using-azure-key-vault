#  Vault Cluster Auto Unseal on K8s with AZ Key Vault

## Deploy Vault Cluster on K8s with Raft Backend using Helm Chart & Vault Auto Unseal with AZ Key Vault LLD

![alt text](./images/auto-unseal-vault-k8s-lld.png)

## Deploy Vault Auto Unseal with Azure KV LLD

![alt text](./images/akv-lld.png)

## 🚀This project highlights🚀

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

- **Using Terraform Remote Backend to securly store state files and secure state management**
- **The entire Azure Key Vault infrastructure is fully automated and provisioned using Terraform, with no manual (clickops) intervention.**

## Used Technologies
1. **Kubernetes**
2. **Helm Package Manger**
3. **Helm Chart & Helm Repository**
4. **Hashicorp Vault**
5. **K8s API resources - K8s secrets,statefulsets,persistent volumes,persistent volumes claims,storage classes & many more**
6. **Microsoft EntraID**
7. **App Registration(Microsoft EntraID)**
8. **Microsoft Graph API**
9. **Azure Subscription**
10. **Resource Group**
11. **Azure Key Vault**
12. **Azure Cloud KMS Key**
13. **Azure IAM & RBAC**
14. **Terraform (IAC)**
15. **Terraform Cloud (Secure State Management)**

## Project Implementation Guidelines Step by Step

This project involves 4 parts to do implementation:
1. *Prequsities setup in Azure Cloud*
2. *Create Remote Backend in app.terraform.io for storing state files & state management using terraform*
3. *Create entire Azure Key Vault infrastructure using terraform*
4. *Deploy Vault cluster on K8s using helm & configure Vault Auto Unseal with Azure Key Vault using helm*

### 1. Prequsities setup in Azure Cloud 

![alt text](./images/prequisites.png)

### 2. Create Remote Backend in app.terraform.io for storing state files & state management using terraform

```bash
backend
├── main.tf 
├── outputs.tf
├── terraform.tfvars
├── variables.tf
└── versions.tf
```
1. Go to backend directory
2. Create `terraform.tfvars` vars files for storing variable values
3. `terraform init` 
4. `terraform fmt`
5. `terraform validate`
6. `terraform plan`
7. `terraform apply -auto-approve`

### 3. Create entire Azure Key Vault infrastructure using terraform 

```bash
├── app-register.tf
├── azure-key-vault.tf
├── backend.tf
├── outputs.tf
├── variables.tf
└── versions.tf
```
1. Go to parent directory of the project
2. Modify and add your `backend config of hcp terraform` in backend.tf file
3. Do `terraform login` for authenticating to teraform cloud
4. Do `terraform init` for initializing hcp terraform backend and provider plugins
5. `terraform fmt`
6. `terraform validate`
5. `terraform plan` 
6. `terraform apply -auto-approve`

### 4. Deploy Vault cluster on K8s using helm & configure Vault Auto Unseal with Azure Key Vault using helm

1. Create namespce to deploy vault in k8s --> `kubectl create ns vault`
2. Create k8s secret to authenticate the azure key vault and obtain cloud key(unseal key) from azure key vault services
    ```bash
    kubectl create secret generic azure-secrets \
    --from-literal=tenant-id=<AZURE_TENANT_ID> \
    --from-literal=client-id=<AZURE_CLIENT_ID> \
    --from-literal=client-secret=<AZURE_CLIENT_SECRET> \
    -n vault
    ```
3. Check your created k8s secret
    ```bash
    kubectl get secret -n vault
    NAME            TYPE     DATA   AGE
    azure-secrets   Opaque   3      6s
    ```

    ```bash
    kubectl describe secret azure-secrets -n vault
    Name:         azure-secrets
    Namespace:    vault
    Labels:       <none>
    Annotations:  <none>

    Type:  Opaque

    Data
    ====
    tenant-id:      36 bytes
    client-id:      36 bytes
    client-secret:  40 bytes
    ```

4. Create customized configuration helm file to deploy vault cluster in k8s and integrate with azure key vault for vault auto-unseal process 
    ```bash
    helm-vault-raft-azkv-auto-unseal-values.yaml
    ````

5. Deploy vault cluster in k8s and configure the azure key vault for vault auto-unseal process with customized configuration helm file using helm
    ```bash
    helm install vault hashicorp/vault --values helm-vault-raft-azkv-auto-unseal-values.yaml -n vault
    ```

6. Check all k8s api resources in vault namespace
    ```bash
    kubectl get all -n vault
    NAME                                        READY   STATUS              RESTARTS   AGE
    pod/vault-0                                 0/1     ContainerCreating   0          96s
    pod/vault-1                                 0/1     ContainerCreating   0          96s
    pod/vault-2                                 0/1     ContainerCreating   0          96s
    pod/vault-agent-injector-56459c7545-zznff   1/1     Running             0          97s

    NAME                               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
    service/vault                      ClusterIP   10.132.106.26   <none>        8200/TCP,8201/TCP   97s
    service/vault-active               ClusterIP   10.132.88.55    <none>        8200/TCP,8201/TCP   97s
    service/vault-agent-injector-svc   ClusterIP   10.132.70.38    <none>        443/TCP             97s
    service/vault-internal             ClusterIP   None            <none>        8200/TCP,8201/TCP   97s
    service/vault-standby              ClusterIP   10.132.33.67    <none>        8200/TCP,8201/TCP   97s
    service/vault-ui                   ClusterIP   10.132.188.27   <none>        8200/TCP            97s

    NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/vault-agent-injector   1/1     1            1           97s

    NAME                                              DESIRED   CURRENT   READY   AGE
    replicaset.apps/vault-agent-injector-56459c7545   1         1         1       97s

    NAME                     READY   AGE
    statefulset.apps/vault   0/3     97s
    ```

7. Vault server is not initialized yet
    ```bash
    kubectl exec -it vault-0 -n vault -- vault status

    Key                      Value
    ---                      -----
    Seal Type                azurekeyvault     <----- vault seal type is `azurekeyvault`
    Recovery Seal Type       n/a
    Initialized              false
    Sealed                   true
    Total Recovery Shares    0
    Threshold                0
    Unseal Progress          0/0
    Unseal Nonce             n/a
    Version                  1.19.0
    Build Date               2025-03-04T12:36:40Z
    Storage Type             raft
    Removed From Cluster     false
    HA Enabled               true
    ```

8. Initialize the vault server using vault initialze shell script & join the other nodes to vault leader nodes

    ```bash
    ./vault-initialize.sh

    Checking Vault initialization status on vault-0...
    command terminated with exit code 2
    Vault is not initialized. Initializing now...
    Initialization complete. Output saved to unseal.json.
    Joining vault-1 to raft cluster at vault-0...
    Key       Value
    ---       -----
    Joined    true
    Joining vault-2 to raft cluster at vault-0...
    Key       Value
    ---       -----
    Joined    true
    All nodes have been instructed to join the raft cluster
    ```

9. Now vault nodes are up and running
    
    ```bash
    kubectl get pods -n vault
    NAME                                    READY   STATUS    RESTARTS   AGE
    vault-0                                 1/1     Running   0          13m
    vault-1                                 1/1     Running   0          13m
    vault-2                                 1/1     Running   0          13m
    vault-agent-injector-56459c7545-zznff   1/1     Running   0          13m
    ```
10. Vault nodes are sucessfully auto-useal using azure key vault

    ```bash
    kubectl exec -it vault-0 -n vault -- vault status
    Key                      Value
    ---                      -----
    Seal Type                azurekeyvault
    Recovery Seal Type       shamir
    Initialized              true      <---- vault is already initialized 
    Sealed                   false     <---- vault os sucessfully auto-unsealed by azure key vault
    Total Recovery Shares    5
    Threshold                3
    Version                  1.19.0
    Build Date               2025-03-04T12:36:40Z
    Storage Type             raft
    Cluster Name             vault-cluster-105a985c
    Cluster ID               5a58a1fc-8aee-40b4-d4d2-743936d5b210
    Removed From Cluster     false
    HA Enabled               true
    HA Cluster               https://vault-0.vault-internal:8201
    HA Mode                  active
    Active Since             2025-05-18T10:27:06.018636378Z
    Raft Committed Index     54
    Raft Applied Index       54
    ```

11. Port Forward the vault ui service
    
    ```bash
    kubectl port-forward svc/vault-ui --address 0.0.0.0 8200:8200 -n vault
    ```
    *You can call the vault server on port 8200 from browser(GUI access)*
    ![alt text](./images/vault-server-ui.png)

    *I have created 3 secret engines(AWS,Azure,GCP) to prove the data persitence and data synchronization in later steps*
    ![alt text](./images/vault-secret-operator.png)


12. Check the vault leaders and follower

    *Vault-0 node is leader now*
    ```bash
    kubectl exec -it vault-0 -n vault -- vault operator raft list-peers

    Node       Address                        State       Voter
    ----       -------                        -----       -----
    vault-0    vault-0.vault-internal:8201    leader      true
    vault-1    vault-1.vault-internal:8201    follower    true
    vault-2    vault-2.vault-internal:8201    follower    true 
    ```
13. POC of *HA,Fault Tolerance & data persitence & synchronization across vault clusters*

    *For the sake of HA & Fault Tolerance, I delele the vault-0 nodes*
    ```bash
    kubectl delete pod vault-0 -n vault

    pod "vault-0" deleted
    ```

    *Vault-0 node is automatically created again(controlled by stateful sets)*
    ![alt text](./images/vault-ha.png)

    *Now, vault-1 automatically elected and become leader*
    ![alt text](./images/vault-1-leader.png)

    *You can see vault data(all secret engines you created before) is persitent even though vault-0 node is down*
    ![alt text](./images/vault-data-persitence.png)

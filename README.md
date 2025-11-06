# Deploy a Scalable EKS Cluster on AWS with Terraform

Modern DevOps relies on automation, scalability, and resilience. When it comes to Kubernetes in the cloud, **Amazon EKS (Elastic Kubernetes Service)** simplifies cluster management — but manual setup can be tedious. That's where **Terraform** comes in.

In this guide, you'll learn how to **deploy a production-ready EKS cluster** with Terraform, including:

- Custom VPC, subnets, and routing
- IAM roles for EKS and worker nodes
- Add-ons like CoreDNS and EBS CSI Driver
- Cluster Autoscaler for dynamic scaling
- MySQL StatefulSet deployment with persistent storage

---

## What You'll Learn

By the end of this tutorial, you'll have an **automated EKS infrastructure** that can:

- Scale automatically based on workload demand
- Maintain high availability across multiple Availability Zones
- Use Terraform for repeatable and versioned deployments
- Deploy stateful applications with persistent volumes

---

## Project Overview

We'll build a complete EKS environment with these components:

| Component | Description |
|-----------|-------------|
| **VPC + Subnets** | Custom networking for EKS |
| **IAM Roles** | Secure permissions for cluster and nodes |
| **EKS Cluster** | Managed Kubernetes control plane |
| **Node Group** | EC2-based worker nodes |
| **Add-ons** | CoreDNS, kube-proxy, EBS CSI Driver |
| **Cluster Autoscaler** | Auto-adjusts node count based on workload |

---

## Architecture Overview

```
+-----------------------------+
|         AWS Cloud           |
|                             |
|   +---------------------+   |
|   |     EKS Cluster     |   |
|   |  (Control Plane)    |   |
|   +----------+----------+   |
|              |              |
|      +-------+--------+     |
|      |   Node Group   |     |
|      | (EC2 Workers)  |     |
|      +----------------+     |
|        ↑      ↑             |
|   Autoscaler  EBS Driver    |
+-----------------------------+
```

---

## Prerequisites

Before you begin, ensure you have:

- AWS Account with appropriate permissions
- Terraform ≥ 1.0 installed
- AWS CLI configured (`aws configure`)
- kubectl installed
- IAM user with admin or EKS-related permissions

---

## Step-by-Step Setup

### **Step 1: Clone the Repository**

Clone the source code from GitHub:

```bash
git clone https://github.com/Ankoay-Feno/kubernetes-autoscaling-aws.git
cd kubernetes-autoscaling-aws/iac
```

---

### **Step 2: Initialize Terraform**

Initialize Terraform to download required providers:

```bash
terraform init
```

---

### **Step 3: Preview and Apply Changes**

Review the infrastructure plan and deploy:

```bash
terraform plan
terraform apply --auto-approve
```

**Note:** The deployment takes approximately 10-15 minutes.

---

## Terraform Outputs

After deployment, Terraform provides useful outputs:

| Output | Description |
|--------|-------------|
| `cluster_endpoint` | API server URL |
| `cluster_oidc_issuer_url` | OIDC provider for IAM roles |
| `node_group_id` | Worker node group identifier |
| `vpc_id` | ID of the created VPC |
| `kubeconfig_update_command` | Command to update kubeconfig |

---

### **Step 4: Configure kubectl**

Once complete, configure kubectl to interact with your cluster:

```bash
$(terraform output -raw kubeconfig_update_command)
```

Verify the cluster nodes:

```bash
kubectl get nodes
```

**Expected Output:** You'll see a single node initially, as no workload has triggered autoscaling yet.

![Single Node](https://raw.githubusercontent.com/Ankoay-Feno/kubernetes-autoscaling-aws/refs/heads/main/assets/single%20nodes.png)

---

## Deploy MySQL StatefulSet

Now let's deploy a MySQL replication setup to demonstrate autoscaling.

### **Step 5: Create a StorageClass**

Navigate to the MySQL configuration directory and create a StorageClass:

```bash
cd ../mysql-statefulset
kubectl apply -f 00-mysql-storageclass.yaml
```

Verify the StorageClass:

```bash
kubectl get storageclass
kubectl describe storageclass gp3
```

---

### **Step 6: Create ConfigMap**

The ConfigMap contains initialization scripts for MySQL master and slave replicas:

```bash
kubectl apply -f 01-mysql-configmap.yaml
```

Verify the ConfigMap:

```bash
kubectl get configmap
kubectl describe configmap mysql
```

---

### **Step 7: Create Services**

Create headless and NodePort services for MySQL:

```bash
kubectl apply -f 02-mysql-services.yaml
```

Verify the services:

```bash
kubectl get services
kubectl describe service mysql
kubectl describe service mysql-read
```

---

### **Step 8: Deploy MySQL StatefulSet**

Now deploy the MySQL StatefulSet with 3 replicas (1 master + 2 slaves):

```bash
kubectl apply -f 03-mysql-statefulset.yaml
```

Verify the deployment:

```bash
kubectl get statefulset
kubectl describe statefulset mysql
kubectl get pods -w
```

**Watch the Autoscaling in Action:**

As the StatefulSet creates 3 pods, you'll notice the cluster autoscaler adding a second node automatically. The single node cannot handle the resource requirements of all 3 MySQL pods.

![Nodes Scale Up](https://raw.githubusercontent.com/Ankoay-Feno/kubernetes-autoscaling-aws/refs/heads/main/assets/nodes%20scale%20up.png)

Check the scaled nodes:

```bash
kubectl get nodes
```

You should now see **2 nodes** instead of 1!

---

## Why This Setup Works

✅ **Scalable** — Cluster Autoscaler dynamically adjusts node count based on pod requirements

✅ **Secure** — Private subnets + IAM least-privilege roles protect your infrastructure

✅ **Modular** — Split configuration into modules for networking, IAM, and EKS for maintainability

✅ **Production-ready** — Includes monitoring, storage add-ons, and persistent volumes

✅ **Cost-efficient** — Nodes scale down when workload decreases

---

## Cleanup

To destroy all resources and avoid AWS charges:

```bash
# Delete Kubernetes resources first
kubectl delete -f 03-mysql-statefulset.yaml
kubectl delete -f 02-mysql-services.yaml
kubectl delete -f 01-mysql-configmap.yaml
kubectl delete -f 00-mysql-storageclass.yaml

# Then destroy Terraform infrastructure
cd ../iac
terraform destroy --auto-approve
```


With Terraform as your infrastructure-as-code backbone, your EKS deployments become repeatable, versioned, and scalable — the DevOps way.


**Happy Terraforming! 🚀**

---

**Repository:** [kubernetes-autoscaling-aws](https://github.com/Ankoay-Feno/kubernetes-autoscaling-aws)

**Author:** Ankoay-Feno

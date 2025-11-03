#  Deploy a Scalable EKS Cluster on AWS with Terraform

Modern DevOps relies on automation, scalability, and resilience. When it comes to Kubernetes in the cloud, **Amazon EKS (Elastic Kubernetes Service)** simplifies cluster management — but manual setup can be tedious.

That's where **Terraform** comes in.

In this guide, you'll learn how to **deploy a production-ready EKS cluster** with Terraform, including:

- Custom VPC, subnets, and routing
- IAM roles for EKS and worker nodes
- Add-ons like CoreDNS and EBS CSI Driver
- Cluster Autoscaler for dynamic scaling

---

## What You'll Learn

By the end of this tutorial, you'll have an **automated EKS infrastructure** that can:

- Scale automatically based on workload demand
- Maintain high availability across multiple Availability Zones
- Use Terraform for repeatable and versioned deployments

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
``` ascii
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

### **Step 1: Clone the repository**

Clone source code on github
```bash
    git clone https://github.com/Ankoay-Feno/kubernetes-autoscaling-aws.git
```

---

### **Step 2: Init terraform**


```bash
    cd kubernetes-autoscaling-aws/iac
    terraform init
```


---

##  **Step 3: preview and apply changes **
Run these commands to deploy:
```bash
terraform plan
terraform apply --auto-approve
```

## Outputs

After deployment, Terraform provides useful outputs:

| Output | Description |
|--------|-------------|
| `cluster_endpoint` | API server URL |
| `cluster_oidc_issuer_url` | OIDC provider for IAM roles |
| `node_group_id` | Worker node group identifier |
| `vpc_id` | ID of the created VPC |
update kubeconfig | kubeconfig_update_command | command to update kubeconfig
---


\
\
Once complete, configure kubectl:
```bash
$(terraform output -raw kubeconfig_update_command)
```
\
\
With command ``` kubectl get nodes ``` we have an outputs like this 

![nodes](https://raw.githubusercontent.com/Ankoay-Feno/kubernetes-autoscaling-aws/refs/heads/main/assets/single%20nodes.png)


---

## ** Step 4: Create a config map for all replicat  master and slave**

```bash
cd ../
```
## Why This Setup Works

**Scalable** — Cluster Autoscaler dynamically adjusts node count  
**Secure** — Private subnets + IAM least-privilege roles  
**Modular** — Split config into modules for networking, IAM, and EKS  
**Production-ready** — Includes monitoring and storage add-ons

---

## Final Thoughts

This setup provides a foundation for production-grade Kubernetes on AWS. From here, you can integrate:

- **Ingress Controller** (NGINX or ALB)
- **Monitoring stack** (Prometheus + Grafana)
- **GitOps workflow** (ArgoCD or Flux)

With Terraform as your infrastructure-as-code backbone, your EKS deployments become repeatable, versioned, and scalable — the DevOps way.

---

**Happy Terraforming!**
# 🚀 Enterprise-Grade Node.js Deployment on AWS EKS

This repository contains the complete Infrastructure as Code (IaC) and configuration files to deploy a containerized Node.js application to a production-ready Amazon EKS (Elastic Kubernetes Service) cluster.

## 📋 Project Overview

This project demonstrates a full-scale DevOps pipeline: from local development and containerization to provisioning complex cloud networking and deploying via Kubernetes.

## 🏗 Architecture Summary

- **Cloud Provider:** AWS (Free Tier Optimized)
- **Infrastructure:** Custom VPC (3 Public Subnets, 3 Private Subnets, NAT Gateway, Internet Gateway)
- **Orchestration:** Amazon EKS (v1.31)
- **Provisioning:** Terraform (v1.5+) using Modular Design
- **Deployment:** Helm v3 (Package Manager)
- **Container Registry:** Docker Hub

## 🛠 Step-by-Step Deployment Journey

### 1. Application Containerization (Docker)
We transformed the Node.js source code into a standardized Docker image. Because the deployment target was AWS Linux (AMD64) and the development machine was a Mac (ARM64), we performed a multi-platform build.

**Build for Cloud Architecture:**
```bash
docker build --platform linux/amd64 -t [your-dockerhub-username]/nodejs-devops-world:v1 .
```

**Push to Registry:**
docker push [your-dockerhub-username]/nodejs-devops-world:v1

### 2. Infrastructure as Code (Terraform)
We provisioned a highly available network and cluster consisting of 52 individual AWS resources.

**Initialization:**
tf init

**The Speculative Plan:**
Generated a binary plan file to ensure the execution would be exactly as previewed.
```bash
terraform plan -out=devops.plan
```
**Execution:**
tf apply "devops.plan"

### 3. Kubernetes Application Management (Helm)
Instead of manual YAML manifests, we used Helm to manage the application lifecycle.

**Chart Initialization:**
ehelm create nodejs-chart

**Configuration (`values.yaml`):**
Mapped the public Service Port (80) to the internal Container Port (3000) and set the service type to LoadBalancer.

**Deployment:**
helm install my-node-app ./nodejs-chart

Before deploying, we had to configure the "Translator" (Helm) to connect the internet to our app.

## Generate Chart:

```bash
helm create nodejs-chart
```

## Configure `values.yaml`:

We modified this file to tell AWS to create a Load Balancer and use our specific image.

```yaml
# Change these specific lines:
image:
  repository: [your-username]/nodejs-devops-world
  tag: "v1"

service:
  type: LoadBalancer
  port: 80         # Public Port (Browser)
  targetPort: 3000 # App Port (Inside Container)
```

## Configure `templates/deployment.yaml`:

We updated the `containerPort` to match our Node.js app's internal port.

```yaml
# Locate the ports section and update:
ports:
  - name: http
templatePort: {{ .Values.service.targetPort }} # Use targetPort (3000)
    protocol: TCP
```

## Final Install:

```bash
helm install my-node-app ./nodejs-chart
```

## ⚠️ Challenges Encountered & Technical Resolutions
This project involved navigating several high-level "breaking changes" and architecture hurdles:
 
### ❌ Issue 1: Terraform EKS Module v21 Upgrade 
Error: Unsupported argument errors for cluster_name and cluster_version.
Cause: The community EKS module updated to version 21, which removed the cluster_ prefix from core variables.
Fix: Refactored `eks.tf` to use `name` and `kubernetes_version` to align with the latest module API.
 
### ❌ Issue 2: The Networking "Chicken & Egg" Problem 
Error: Nodes stayed in NotReady status with CNI plugin not initialized.
Cause: Worker nodes cannot reach a "Ready" state without the VPC-CNI networking driver, but the driver waits for "Ready" nodes to install.
Fix: Implemented `before_compute = true` in the addons configuration within Terraform. This forces EKS to install the network driver on the control plane before the worker nodes boot.
 
### ❌ Issue 3: Docker Platform Mismatch 
Error: ImagePullBackOff with no match for platform in manifest.
Cause: Modern Macs (M1/M2/M3) build ARM64 images by default, incompatible with standard AWS EC2 instances (AMD64).
Fix: Rebuilt the image using the `--platform linux/amd64` flag to ensure the binary was compatible with the cloud environment.
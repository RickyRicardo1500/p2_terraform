# Terraform: Docker & Kurbernetes

## Overview
This project gives students hands-on practice with Terraform using two environments:
1. Local Docker infrastructure
2. A lightweight Kubernetes cluster (k3d or kind)

Students will build, extend, test, and document their infrastructure as code. Both demos are intentionally simple but realistic enough to teach core Terraform concepts: modules, state, variables, outputs, iteration, and dependency graphs.

PART 1 — DOCKER TERRAFORM PROJECT

Goal: Use Terraform to provision a small “local cloud” made of Docker containers:
- One frontend (Nginx)
- One backend (Python/Node/Go microservice — can be trivial)
- One database (Postgres)

PART 2 — KUBERNETES TERRAFORM PROJECT

Goal: Use Terraform to manage a tiny Kubernetes cluster using k3d or kind.

## Directory Tree

```
|->Terraform Project
|->README.md
|->terraform-docker/
    |-> main.tf
    |-> variables.tf
    |-> terraform.tfvars
    |-> providers.tf
    |-> modules/
        |-> network/
        |-> postgres/
        |-> backend/
        |-> frontend/
        |-> redis/      # enhancement
|->terraform-k8s
    |-> main.tf
    |-> variables.tf
    |-> providers.tf
    |-> modules/
        |-> namespace/
        |-> deployment/
        |-> service/
        |-> hpa/      # enhancement
```

## Setup Steps (Docker)
1. Select **Amazon Linux 2023** EC2 instance (t3.micro).
2. Create a new key pair or reuse a created key from the drop down menu.
3. Allow SSH(22) traffic from my IP, allow HTTPS(443) and HTTP(80) from Anywhere IPv4, and allow custom TCP with Port 8080 from Anywhere IPv4
4. Launch the instance using the Pulbic IPv4 address
5. SSH into the instance:
```bash
ssh -i MyKeyPair.pem ec2-user@<PUBLIC_IP>
```
If using Putty use insert your keypair in the auth tab then login using your <PUBLIC_IP>

6. Clone Git Repo & change working directory
```bash
git clone https://github.com/RickyRicardo1500/p2_terraform.git && cd p2_terraform
cd terraform-docker
```
7. Install & Run docker
```bash
sudo yum install docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```
8. Verify docker (Empty table prints out successfully & processes are running)
```bash
docker ps
systemctl | grep docker
```
9. Install terraform
```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform
```
10. Verify terraform (Terraform installed)
```bash
terraform -version
```
11. Run terraform
```bash
terraform init -upgrade
terraform apply -auto-approve
```
12. Test
```bash
curl http://localhost:8081
```

Result
```bash
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Setup Steps (Kubernetes) *** (Continue from Docker Setup Steps)
1. Change directory
```bash
cd ~/p2_terraform/terraform-k8s
```
2. Install k3d
```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```
3. Create cluster
```bash
k3d cluster create demo-cluster --servers 1 --agents 1 --port "8080:80@loadbalancer"
```
4. Test
```bash
kubectl get nodes
```
5. Run terraform
```bash
terraform init -upgrade
terraform apply -auto-approve
```
10. View resources (Terraform installed)
```bash
kubectl get all -n demo
```
11. Test
```bash
curl http://localhost:8081
```

Delete EC2 instance when done\
Navigate back to AWS EC2 instance via the browser. Under the Instance State Menu, terminate the instance.

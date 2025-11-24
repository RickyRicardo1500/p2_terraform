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

## Setup Steps
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
```
7. Install & Run docker
```bash
sudo yum install docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```
8. Verify docker (Empty table prints out successfully)
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
11. Start Node.js
```bash
node server.js
```
12. Create a systemd unit
```bash
sudo bash -c 'cat > /etc/systemd/system/p1.service <<"UNIT"
[Unit]
Description=CS554 Project 1 service
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/p1
ExecStart=/usr/bin/node /home/ec2-user/p1/server.js
Restart=always
Environment=PORT=8080

[Install]
WantedBy=multi-user.target
UNIT'
```
13. Enable systemctl
```bash
sudo systemctl daemon-reload
```
```bash
sudo systemctl enable --now p1
```
```bash
sudo systemctl status p1 --no-pager
```
14. NGINX Reverse Proxy
```bash
sudo yum install -y nginx
```
```bash
sudo nano /etc/nginx/conf.d/default.conf
```
Delete contents in the file and paste the content below in the file and save it
```bash
server {
    listen       80;
    server_name  _;

    location / {
        proxy_pass         http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
Test the config
```bash
sudo nginx -t
```
16. Reload Nginx
```bash
sudo systemctl restart nginx
```
```bash
sudo systemctl enable nginx
```
17. Test the Cases\
- 1. Happy path: /convert?lbs=0 = 0.000 kg
- 2. Typical: /convert?lbs=150 = 68.039 kg
- 3. Edge: /convert?lbs=0.1 = 0.045 kg
- 4. Error: /convert (missing param) = 400
- 5. Error: /convert?lbs=-5 = 422
- 6. Error: /convert?lbs=NaN = 400

Run commands for test cases in shell below
- 1.
```bash
curl 'http://<PUBLIC_IP>:8080/convert?lbs=0'
```
- 2.
```bash
curl 'http://<PUBLIC_IP>:8080/convert?lbs=150'
```
- 3.
```bash
curl 'http://<PUBLIC_IP>:8080/convert?lbs=150'
```
- 4.
```bash
curl 'http://<PUBLIC_IP>:8080/convert?lbs=0.1'
```
- 5.
```bash
curl 'http://<PUBLIC_IP>:8080/convert'
```
- 6.
```bash
curl 'http://<PUBLIC_IP>:8080/convert?lbs=NaN'
```
18. Delete EC2 instance when done\
    Navigate back to AWS EC2 instance via the browser. Under the Instance State Menu, terminate the instance.

#!/bin/bash
echo "ubuntu:YourSecurePassword123" | chpasswd

until ping -c 1 google.com; do
  echo "Waiting for internet..."
  sleep 5
done

# 1. System Setup
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# 2. Create a Data Volume for Persistence
mkdir -p /opt/mongodb_data
chown 1001:1001 /opt/mongodb_data

# 3. Run MongoDB Container
docker run -d \
  --name mongodb \
  --restart always \
  -p 27017:27017 \
  -v /opt/mongodb_data:/bitnami/mongodb \
  -e MONGODB_DATABASE=todo-db \
  -e MONGODB_ROOT_PASSWORD=${mongodb_root_password} \
  -e MONGODB_USERNAME=ebad \
  -e MONGODB_PASSWORD=${mongodb_password} \
  bitnami/mongodb@sha256:45b7d1b7470d061ddc089b743972916659e0e8a5c0df64db79466b8d5d0c2069

#!/bin/bash
echo "ubuntu:YourSecurePassword123" | chpasswd

until ping -c 1 google.com; do
  echo "Waiting for internet..."
  sleep 5
done

# 1. Update and Install Docker
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# 2. Pull and Run the Backend Container
docker run -d \
  --name todo-backend \
  --restart always \
  -p 5000:5000 \
  -e MONGODB_URI="mongodb://ebad:${mongodb_password}@${db_private_ip}:27017/todo-db?authSource=todo-db" \
  -e PORT=5000 \
  ${docker_username}/todo-backend:latest
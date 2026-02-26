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

# 2. Setup Nginx Configuration as a Reverse Proxy
cat <<EOF > /tmp/nginx.conf
server {
    listen 80;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri /index.html =404;
    }

    location /status/health {
        try_files /health.html =404;
    }

    location /status/db {
        try_files /db.html =404;
    }

    location /api/ {
        proxy_pass http://${backend_private_ip}:5000;
    }
}
EOF

# 3. Run the Frontend Container
docker run -d \
  --name todo-frontend \
  --restart always \
  -p 80:80 \
  -v /tmp/nginx.conf:/etc/nginx/conf.d/default.conf \
  ${docker_username}/todo-frontend:${image_tag}
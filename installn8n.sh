#!/bin/bash

echo "=== NHẬP DOMAIN (VD: n8n.nz03.com) ==="
read -p "Domain: " DOMAIN

echo "=== NHẬP EMAIL để nhận cảnh báo SSL (Let's Encrypt) ==="
read -p "Email: " EMAIL

N8N_PORT=5678

echo "=== Cập nhật hệ thống & cài đặt Docker, NGINX, Certbot ==="
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io nginx certbot python3-certbot-nginx -y
sudo systemctl enable docker
sudo systemctl start docker

echo "=== Tạo container Docker cho n8n ==="
sudo docker rm -f cont_n8n 2>/dev/null
sudo docker run -d --name=cont_n8n \
  -p $N8N_PORT:5678 \
  -e WEBHOOK_URL=https://$DOMAIN/ \
  -e N8N_HOST=$DOMAIN \
  -e N8N_PROTOCOL=https \
  --restart unless-stopped \
  n8nio/n8n

echo "=== Tạo cấu hình NGINX cho domain $DOMAIN ==="
NGINX_CONF="/etc/nginx/sites-available/n8n"

sudo bash -c "cat > $NGINX_CONF" <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:$N8N_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

echo "=== Kích hoạt cấu hình NGINX ==="
sudo ln -sf /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

echo "=== Cấp chứng chỉ SSL với Certbot ==="
sudo certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email

echo "=== HOÀN TẤT! Truy cập https://$DOMAIN để xem n8n ==="

# N8N Installer Script

Đây là script cài đặt `n8n` với Docker và cấu hình SSL sử dụng Certbot để truy cập qua HTTPS bảo mật.

## Tính năng

- Cài đặt Docker và Docker-Compose.
- Chạy container `n8n` trên server của bạn.
- Cấu hình NGINX làm reverse proxy cho `n8n`.
- Cài đặt SSL với Let's Encrypt sử dụng Certbot để có HTTPS bảo mật.

## Yêu cầu

- Server chạy hệ điều hành Linux (Ubuntu khuyến nghị).
- Một tên miền trỏ tới địa chỉ IP của server (ví dụ: `n8n.example.com`).
- Một địa chỉ email hợp lệ để nhận thông báo gia hạn chứng chỉ SSL từ Let's Encrypt.

## Cách sử dụng

### 1. Chạy lệnh sau để thực thi script:

```bash
bash <(curl -s https://raw.githubusercontent.com/sptn03/shellscript/main/installn8n.sh)

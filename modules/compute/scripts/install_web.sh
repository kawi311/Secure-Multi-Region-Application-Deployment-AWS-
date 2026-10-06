#!/bin/bash
yum update -y

yum install -y python3 python3-pip

systemctl stop firewalld
systemctl disable firewalld

pip3 install flask

# 4. Tạo file ứng dụng Python
cat > /opt/app.py << EOF
from flask import Flask, jsonify
import socket
import sys
 
app = Flask(__name__)
 
@app.route('/')
def hello():
    hostname = socket.gethostname()
    return f"<h1>Hello from {hostname}</h1>"
 
@app.route('/health')
def health_check():
    print("Health check endpoint was called.", file=sys.stderr)
    return jsonify({"status": "ok"})
 
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF
# 5. Tạo file dịch vụ systemd để quản lý ứng dụng
cat > /etc/systemd/system/flask-app.service << EOF
[Unit]
Description=My Flask Application
After=network.target
 
[Service]
ExecStart=/usr/bin/python3 /opt/app.py
Restart=always
 
[Install]
WantedBy=multi-user.target
EOF
# 6. Kích hoạt và khởi động dịch vụ Flask
systemctl daemon-reload
systemctl enable flask-app.service
systemctl start flask-app.service
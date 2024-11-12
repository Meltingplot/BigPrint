#!/bin/bash
set -e

# Install the required packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y nginx git wget unzip

sudo bash -c 'cat > /etc/nginx/sites-available/reverse-proxy' <<"EOF"
map $http_upgrade $proxy_connection {
    'websocket' 'upgrade';
    default 'keep-alive';
}

server {
  listen 80;
  listen [::]:80;

  gzip on;
  gzip_http_version 1.1;
  gzip_vary on;

  client_max_body_size 1024M;

  location = /webcam {
      proxy_pass http://10.42.0.3:8081;
      proxy_buffering off;

      # Headers for client browser NOCACHE + CORS origin filter
      add_header 'Cache-Control' 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
      expires off;
      add_header    'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
      add_header    'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept' always;
      add_header    'Access-Control-Allow-Origin' '*';
  }

  location = /snapshot {
      proxy_pass http://10.42.0.3/picture/1/current/;
      proxy_buffering off;

      # Headers for client browser NOCACHE + CORS origin filter
      add_header 'Cache-Control' 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
      expires off;
      add_header    'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
      add_header    'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept' always;
      add_header    'Access-Control-Allow-Origin' '*';
  }

  location / {
      proxy_pass         http://127.0.0.1:8080;
      proxy_http_version 1.1;
      proxy_set_header   Upgrade $http_upgrade;
      proxy_set_header   Connection $proxy_connection;
      proxy_set_header   Host $host;
      proxy_cache_bypass $http_upgrade;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_set_header   X-Session-Key $http_x_session_key;

      # WebSocket support
      proxy_set_header Sec-WebSocket-Protocol $http_sec_websocket_protocol;
      proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
      proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
      proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;
      proxy_set_header Sec-GPC $http_sec_gpc;

      proxy_read_timeout 1d;
  }
} 
EOF

# replace "Url": "http://*" in http.json with "Url": "http://*:8080"
sudo sed -i 's|"Url": "http://\*"|"Url": "http://*:8080"|' /opt/dsf/conf/http.json
sudo systemctl restart duetwebserver

sudo rm /etc/nginx/sites-enabled/reverse-proxy || true
sudo rm /etc/nginx/sites-enabled/default || true
sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
sudo systemctl restart nginx

# allow password authentication
# replace KbdInteractiveAuthentication no with KbdInteractiveAuthentication yes in sshd_config
sudo sed -i 's|KbdInteractiveAuthentication no|KbdInteractiveAuthentication yes|' /etc/ssh/sshd_config
sudo systemctl restart sshd

wget https://github.com/Meltingplot/BigPrint/archive/refs/heads/duet-3.5.3-sbc.zip
unzip duet-3.5.3-sbc.zip
sudo mv -f BigPrint-duet-3.5.3-sbc/duet-config/filaments/* /opt/dsf/sd/filaments/
sudo mv -f BigPrint-duet-3.5.3-sbc/duet-config/macros/* /opt/dsf/sd/macros/
sudo mv -f BigPrint-duet-3.5.3-sbc/duet-config/sys/* /opt/dsf/sd/sys/

# Change ownership to the dsf user
sudo chown -R dsf:dsf /opt/dsf/sd/

rm -rf duet-3.5.3-sbc.zip BigPrint-duet-3.5.3-sbc

sudo nmcli connection modify Hotspot connection.autoconnect yes
sudo nmcli connection modify Hotspot ipv4.method shared
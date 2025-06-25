#!/bin/bash
set -e

# Check if Python version is 3.9 or greater
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
REQUIRED_VERSION="3.9"

if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]]; then 
    echo "Python version is $PYTHON_VERSION, which is 3.9 or greater."
else
    echo "Python version is $PYTHON_VERSION, which is less than 3.9. Please upgrade Python."
    exit 1
fi

# Check if the system is running Debian Bookworm or newer
if ! grep -q 'bookworm\|trixie\|sid' /etc/os-release; then
    echo "This script requires Debian Bookworm or newer."
    exit 1
fi

# Install the required packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y nginx git wget unzip rsync

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
      proxy_no_cache 1;
      proxy_cache_bypass 1;

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
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_set_header   X-Session-Key $http_x_session_key;

      proxy_no_cache     1;
      proxy_cache_bypass 1;

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

wget https://github.com/Meltingplot/BigPrint/archive/refs/heads/duet-3.5.4-sbc.zip
unzip -q -u duet-3.5.4-sbc.zip

# use old dsf-config.g
cp -f /opt/dsf/sd/sys/dsf-config.g BigPrint-duet-3.5.4-sbc/duet-config/sys/dsf-config.g || true

# use old machine-override
cp -f /opt/dsf/sd/sys/meltingplot/machine-override BigPrint-duet-3.5.4-sbc/duet-config/sys/meltingplot/machine-override || true

sudo rsync -a BigPrint-duet-3.5.4-sbc/duet-config/filaments/ /opt/dsf/sd/filaments/
sudo rsync -a BigPrint-duet-3.5.4-sbc/duet-config/macros/ /opt/dsf/sd/macros/
sudo rsync -a BigPrint-duet-3.5.4-sbc/duet-config/sys/ /opt/dsf/sd/sys/

# Change ownership to the dsf user
sudo chown -R dsf:dsf /opt/dsf/sd/

rm -rf duet-3.5.4-sbc.zip BigPrint-duet-3.5.4-sbc

sudo nmcli connection modify Hotspot connection.autoconnect yes
sudo nmcli connection modify Hotspot ipv4.method shared

# https://www.raspberrypi.com/documentation/computers/configuration.html#uarts-and-device-tree
echo "dtoverlay=disable-bt" | sudo tee -a /boot/firmware/config.txt
sudo systemctl disable bluetooth
sudo systemctl disable hciuart

enable_estop="no"
if [ -t 0 ]; then
    read -p "Do you want to enable the E-Stop? (yes/[no]): " enable_estop
else
    echo "Do you want to enable the E-Stop? (yes/[no]): "
    read enable_estop
fi

if [[ "$enable_estop" == "yes" ]]; then
    sudo sed -i 's|M117 "Enable E-Stop Check in Production! Go to /sys/meltingplot/ce-declaration and enable M582"|;M117 "Enable E-Stop Check in Production! Go to /sys/meltingplot/ce-declaration and enable M582"|' /opt/dsf/sd/sys/meltingplot/ce-declaration
    sudo sed -i 's|;M582 T2|M582 T2|' /opt/dsf/sd/sys/meltingplot/ce-declaration

    sudo sed -i 's|M117 "Enable E-Stop Check in Production! Go to /sys/daemon and enable M112"|;M117 "Enable E-Stop Check in Production! Go to /sys/daemon and enable M112"|' /opt/dsf/sd/sys/daemon.g
    sudo sed -i 's|; M112 ; emergency shutdown|M112 ; emergency shutdown|' /opt/dsf/sd/sys/daemon.g
    echo "E-Stop has been enabled."
else
    echo "E-Stop has not been enabled."
fi
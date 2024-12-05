#!/bin/bash
set -e

# Check if the system is running Debian Bookworm or newer
if ! grep -q 'bookworm\|trixie\|sid' /etc/os-release; then
    echo "This script requires Debian Bookworm or newer."
    exit 1
fi

sudo apt update
sudo apt upgrade -y
sudo apt install -y python3-picamera2

# https://www.raspberrypi.com/documentation/computers/configuration.html#uarts-and-device-tree
echo "dtoverlay=disable-bt" | sudo tee -a /boot/firmware/config.txt
sudo systemctl disable bluetooth
sudo systemctl disable hciuart

python3 -m venv --system-site-packages venv
source venv/bin/activate
pip install meltingplot.rpi_camera
sudo rpi-camera install
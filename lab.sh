#!/bin/bash

docker_compose_file="kali.yaml"
user_name=$(logname)

stop_services() {
    echo "Stopping Docker and OpenVPN..."
    docker compose -f "$docker_compose_file" down
    pkill -f "openvpn config.ovpn"
    echo "Services stopped!"
    exit 0
}

if [ "$1" == "-stop" ]; then
    stop_services
fi

running_containers=$(docker compose -f "$docker_compose_file" ps -q)

if [ -n "$running_containers" ]; then
    echo "Stopping existing instances..."
    docker compose -f "$docker_compose_file" down
fi

echo "Starting VPN..."
openvpn config.ovpn &
VPN_PID=$!

sleep 5

if ps -p $VPN_PID > /dev/null; then
    echo "VPN connected successfully!"
else
    echo "Error connecting to VPN."
    exit 1
fi

echo "Starting Docker service..."
docker compose -f "$docker_compose_file" up -d

sleep 5

firefox_profile_dir="/tmp/firefox-kiosk-profile"
sudo -u "$user_name" mkdir -p "$firefox_profile_dir"

sudo -u "$user_name" firefox --no-remote --profile "$firefox_profile_dir" --kiosk http://localhost:3000 &


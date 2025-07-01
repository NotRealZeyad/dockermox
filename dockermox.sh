#!/bin/bash

# Create the /etc/docker directory if it doesn't exist
sudo mkdir -p /etc/docker

# Write the JSON content to /etc/docker/daemon.json
sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "data-root": "/home/user/docker"
}
EOF'

echo "daemon.json created successfully in /etc/docker."
sleep 4
echo "Attempting to run Dockerd as a service..."
sleep 2

# Create the systemd service file for Dockerd Command
sudo bash -c 'cat > /etc/systemd/system/dockerd-command.service <<EOF
[Unit]
Description=Dockerd Command
After=network.target

[Service]
ExecStart=/usr/bin/dockerd
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd and enable the service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable dockerd-command
sudo systemctl start dockerd-command

echo "Dockerd Command service installed and started."
sleep 3
echo "Attempting to create and run Dockermox"
docker run -itd --name proxmoxve --hostname pve -p 8006:8006 --privileged rtedpro/proxmox:8.4.x
sleep 2
echo "IMPORTANT!!: IF YOU GET A CONFLICT ERROR SAYING THAT THE NAME PROXMOXVE IS ALREADY IN USE, THIS IS TOTALLY NORMAL PLEASE IGNORE IT AND LET THE SCRIPT CONTINUE"
sleep 5
docker start proxmoxve
echo "Dockermox has started successfully started please access proxmox at 127.0.0.1:8006 on your browser"
sleep 1
echo "Thank you for using Dockermox Setup made by NotRealZeyad (script maker) and Rtedpro (Dockermox creator)"

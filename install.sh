#!/bin/bash

# Install Omada Software Controller
# It is recommended to update repository and upgrade system before installing dependencies and omada software controller:
apt update; apt upgrade -y
apt install apt-transport-https curl wget python3-setuptools -y

# Install Basic Software
apt install ufw git vim lm-sensors htop neofetch cron -y

# Adding focal-security to sources list
echo "deb http://security.ubuntu.com/ubuntu focal-security main" | tee /etc/apt/sources.list.d/focal-security.list
deb http://security.ubuntu.com/ubuntu focal-security main

# Install libssl1.1 which is dependency for MongoDB 4.4
apt-get install libssl1.1
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb
apt install -y ./libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb

# Install MongoDB
apt install -y software-properties-common
wget -qO- https://www.mongodb.org/static/pgp/server-4.4.asc | tee /etc/apt/trusted.gpg.d/mongodb-org-4.4.asc
add-apt-repository -y "deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse"
apt install -y mongodb-org

# Install omada dependencies available over the repo (Java8, jsvc and curl)
apt install -y openjdk-8-jre-headless jsvc curl

# Download and install Omada Software Controller
# Omada SDN Software Controller v5.13.30.8
wget https://static.tp-link.com/upload/software/2024/202402/20240227/Omada_SDN_Controller_v5.13.30.8_linux_x64.deb
apt install -y ./Omada_SDN_Controller_v5.13.30.8_linux_x64.deb

# Echo Scripts
echo "# Add Custom SSH Port" >> /etc/ssh/sshd_config                 # Add Custom SSH Port
echo "Port 2234" >> /etc/ssh/sshd_config                             # Add Custom SSH Port
echo "# Launch Neofetch" >> ~/.bashrc                                # Launch Neofetch
echo "neofetch" >> ~/.bashrc                                         # Launch Neofetch
echo "# Schedule Reboot Cron" >> /etc/crontab                        # Schedule Reboot Cron
echo "55 2 * * * root reboot" >> /etc/crontab                        # Schedule Reboot Cron

# Configure Firewall Rules
ufw limit 22/tcp                                                     # SSH (Secure Shell)
ufw allow 80/tcp                                                     # HTTP (Hypertext Transfer Protocol)
ufw allow 443/tcp                                                    # HTTPS (Hypertext Transfer Protocol Secure)
ufw allow 8088/tcp                                                   # Omada Controller
ufw allow 8843/tcp                                                   # Omada Controller
ufw allow 8043/tcp                                                   # Omada Controller
ufw allow 29810:29814/tcp						                     # Omada Controller
ufw allow 29810/udp                                                  # Omada Controller
ufw allow 2234/tcp							                         # Custom SSH Port
ufw allow OpenSSH
ufw default deny incoming
ufw default allow outgoing
ufw enable
ufw reload

# Start/Enable System Services
systemctl daemon-reload
systemctl enable ufw --now
systemctl enable --now cron
systemctl start --now cron

# Set timedatectl
timedatectl set-timezone Asia/Manila
timedatectl set-ntp true
timedatectl set-local-rtc yes

# Add user
adduser nikki
usermod -aG sudo "nikki"

# System Reboot
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"

sleep 5
reboot
sudo echo nameserver 1.1.1.1 > /etc/resolv.conf

sudo echo nameserver 1.0.0.1 > /etc/resolv.conf

sudo systemctl restart systemd-resolved

DV_SAVE=$(cat /etc/debian_version)

echo buster | sudo tee /etc/debian_version >/dev/null

curl -s https://install.zerotier.com | sudo bash

echo $DV_SAVE | sudo tee /etc/debian_version >/dev/null

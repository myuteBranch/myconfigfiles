#!/bin/bash

echo "network:
    version: 2
    ethernets:
        eth0:
            addresses: [10.0.0.15/24]
            nameservers:
                addresses: [10.0.0.1]
            routes:
                - to: default
                  via: 10.0.0.1
" | sudo tee /etc/netplan/50-cloud-init.yaml
sudo chmod 600 /etc/netplan/50-cloud-init.yaml
sudo netplan try

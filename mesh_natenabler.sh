#!/bin/bash
echo "****************************************************\n"
echo "v0.1 AMorales - mesh_natenabler.sh"
echo "This scripts helps to modify default connector behavior for site-2-site (mesh networking scenarios). It enables Hide NAT for the remote locations\n"
echo "Take into consideration that default behavior for Agents is base on Hide NAT, but not for mesh. So this script enables that feature.  \n"
echo "****************************************************\n"

# Backup location
backup_file="$HOME/iptables_backup.rules"

# Supersu
if [ "$(id -u)" != "0" ]; then
    echo "WARNING: This script must be run with superuser privileges. Please use sudo."
    exit 1
fi

iptables-save > "$backup_file"

# Check for connector ip address and valid ip 
read -p "\n 1. Please introduce the connector routed IP address: " connector_ip
if ! [[ "$connector_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address. Exiting."
    exit 1
fi

# Mesh/peer networks behind and validate
read -p "\n 2. Enter one or more networks (e.g., 10.12.0.0/16 192.168.0.0/24): " networks
if [ -z "$networks" ]; then
    echo "No networks provided. Exiting."
    exit 1
fi

iptables_command="iptables -t nat -I POSTROUTING"

for network in $networks; do
    iptables_command+=" -s $network"
done

# Add the NAT to the connector
iptables_command+=" -d 0/0 -j SNAT --to-source $connector_ip -m comment --comment 'QSASE disable NAT inside the VPN community'"

# Run command
eval "$iptables_command"

# Last check if useful
if [ $? -eq 0 ]; then
    echo "\n 3. IPTABLES rule added successfully!!!"
        # Ask the user if they want to save the iptables configuration permanently
    read -p "\n 4. Do you want to save the iptables configuration permanently? (y/n): " save_config

    if [ "$save_config" == "y" ]; then
        # Save the iptables rules permanently
        iptables-save > /etc/iptables/rules.v4
        echo "---- YAY! Iptables configuration saved permanently in /etc/iptables/rules.v4"
    else
        echo "---- NAH! Iptables configuration not saved..."
    fi
else
    echo "Error restoring :( see logs"
    iptables-restore < "$backup_file"
    exit 1
fi

#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Check if username is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Set username from command line argument
USERNAME=$1

# Create user
useradd -m -s /bin/bash $USERNAME

# Generate SSH key pair for the user
sudo -u $USERNAME ssh-keygen -f "/home/$USERNAME/.ssh/id_rsa" -N ""

# Move the public key to authorized_keys
cat "/home/$USERNAME/.ssh/id_rsa.pub" >> "/home/$USERNAME/.ssh/authorized_keys"

# Set correct permissions
chmod 700 "/home/$USERNAME/.ssh"
chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
chown -R $USERNAME:$USERNAME "/home/$USERNAME/.ssh"

# Display instructions for the user
echo "User $USERNAME created with SSH key pair."
echo "Private key is in /home/$USERNAME/.ssh/id_rsa"
echo "Public key is in /home/$USERNAME/.ssh/id_rsa.pub"

# Open id_rsa for editing using nano
echo "Opening id_rsa for editing..."
sudo -u $USERNAME nano "/home/$USERNAME/.ssh/id_rsa"
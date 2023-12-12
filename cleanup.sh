#!/bin/bash

# Function to handle errors
handle_error() {
    local exit_code=$?
    echo "Error occurred with exit code $exit_code."
    exit $exit_code
}

# Trap errors
trap 'handle_error' ERR

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Check if username is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username=$1
container_name=$username

# Stop and remove Docker container
if docker inspect -f '{{.State.Status}}' $container_name &>/dev/null; then
    docker stop $container_name
    docker rm $container_name
    echo "Docker container $container_name stopped and removed successfully."
else
    echo "Docker container $container_name not found or already stopped."
fi

# Delete directory
directory="/raid/dockerv/$username"
if [ -d "$directory" ]; then
    rm -rf $directory
    echo "Directory $directory deleted successfully."
else
    echo "Directory $directory not found."
fi

# Delete Linux user and its home directory
if id "$username" &>/dev/null; then
    userdel -r $username
    echo "User $username and home directory deleted successfully."
else
    echo "User $username not found."
fi
#!/bin/bash

# Function to display an error message and exit
die() {
    echo "Error: $1" >&2
    exit 1
}

# Check if the script is executed with sudo
[[ $EUID -ne 0 ]] && die "This script requires superuser privileges. Please run with sudo."

# Check if the required arguments are provided
[[ $# -lt 5 ]] && die "Usage: $0 <container_name> <user_folder> <image_name> <gpu_memory> <first_port> [--gpu gpu_argument] [docker_params...]"

# Generate a random 12-character password
JUPYTER_PASSWORD=$(openssl rand -base64 12) || die "Failed to generate a random password"

# Extract arguments
CONTAINER_NAME=$1
USER_FOLDER_NAME=$2
IMAGE=$3
GPU_MEMORY=$4
FIRST_PORT=$5
shift 5

# Handle GPU argument
if [[ $1 == "--gpu" ]]; then
    GPU_ARG="--gpus=device=$2"
    shift 2
fi

# Set the path for the user's folder
USER_FOLDER="/raid/dockerv/$USER_FOLDER_NAME"
mkdir -p "$USER_FOLDER" || die "Failed to create user folder: $USER_FOLDER"

# Set Docker container parameters
DEFAULT_DOCKER_PARAMS="-itd -e JUPYTER_PASSWORD=$JUPYTER_PASSWORD"

# Set CPU based on GPU memory
case $GPU_MEMORY in
    5)  CPU=4 ;;
    10) CPU=12 ;;
    20) CPU=16 ;;
    40) CPU=24 ;;
    *)  die "Unsupported GPU memory size: $GPU_MEMORY GB" ;;
esac

# Run the Docker container
sudo docker run $DEFAULT_DOCKER_PARAMS \
    --name "$CONTAINER_NAME" \
    --mount type=bind,source="$USER_FOLDER",target=/workspace \
    -p "$FIRST_PORT:8888" \
    $GPU_ARG \
    --cpus "$CPU" \
    "$@" \
    "$IMAGE" || die "Failed to run Docker container"

# Output container information
cat << EOF
container: $CONTAINER_NAME
user folder: $USER_FOLDER
port: $FIRST_PORT
password: $JUPYTER_PASSWORD
EOF

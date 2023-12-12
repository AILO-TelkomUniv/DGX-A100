#!/bin/bash

# Function to display an error message and exit
function die {
    echo "Error: $1" >&2
    exit 1
}

# Check if the script is executed with sudo
if [ "$(id -u)" != 0 ]; then
    die "This script requires superuser privileges. Please run with sudo."
fi

# Check if the username, Docker image, GPU memory, first port, and --gpu parameter are provided as arguments
if [ "$#" -lt 5 ]; then
    die "Usage: $0 <username> <image_name> <gpu_memory> <first_port> [--gpu gpu_argument] [docker_params...]"
fi

# Generate a random 12-character password
JUPYTER_PASSWORD=$(openssl rand -base64 12) || die "Failed to generate a random password"

# Extract username, Docker image, GPU memory, first port, and --gpu parameter from the command line arguments
USERNAME=$1
IMAGE=$2
GPU_MEMORY=$3
FIRST_PORT=$4
GPU_ARG=""
DOCKER_PARAMS="${@:5}"  # Include all additional arguments as Docker parameters

# Check if the next argument is "--gpu" and extract the corresponding parameter
if [ "$5" == "--gpu" ]; then
    GPU_ARG="--gpus=device=$6"
    shift 2  # Shift to the next set of parameters
fi

# Set the path for the user's folder
USER_FOLDER="/raid/dockerv/$USERNAME"

# Create the user's folder if it doesn't exist
mkdir -p "$USER_FOLDER" || die "Failed to create user folder: $USER_FOLDER"

# Set Docker container parameters
CONTAINER_NAME="$USERNAME"
DEFAULT_DOCKER_PARAMS="-itd -e JUPYTER_PASSWORD=$JUPYTER_PASSWORD"

# Set CPU based on GPU memory
if [ "$GPU_MEMORY" -eq 5 ]; then
    CPU=4
elif [ "$GPU_MEMORY" -eq 10 ]; then
    CPU=8
elif [ "$GPU_MEMORY" -eq 20 ]; then
    CPU=14
elif [ "$GPU_MEMORY" -eq 40 ]; then
    CPU=24
else
    die "Unsupported GPU memory size: $GPU_MEMORY GB"
fi

# Run the Docker container with a bind mount to /workspace
sudo docker run $DEFAULT_DOCKER_PARAMS \
    --name $CONTAINER_NAME \
    --mount type=bind,source="$USER_FOLDER",target=/workspace \
    -p $FIRST_PORT:8888 \
    $GPU_ARG \
    --cpus $CPU \
    $DOCKER_PARAMS \
    $IMAGE || die "Failed to run Docker container"

echo "container: $CONTAINER_NAME"
echo "user: $USERNAME"
echo "port: $FIRST_PORT"
echo "password: $JUPYTER_PASSWORD"
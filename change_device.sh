#!/bin/bash
NAME=$1
IMAGE_TAG=$2
GPU_MEMORY=$3
PORT=$4
MIG_UUID=$5

sudo docker commit $NAME $NAME:$IMAGE_TAG

sudo docker container rename $NAME $NAME+"_old"

sudo ./run.sh $NAME $NAME:$IMAGE_TAG $GPU_MEMORY $PORT --gpus="device=$MIG_UUID"

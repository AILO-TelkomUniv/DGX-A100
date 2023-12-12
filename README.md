<h1 align="center"> DGX-A100 Server </h1>

<p align="center">
    <img src="https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54" style="vertical-align:middle">
    <img src="https://img.shields.io/badge/nVIDIA-%2376B900.svg?style=for-the-badge&logo=nVIDIA&logoColor=white" style="vertical-align:middle">
    <img src="https://img.shields.io/badge/jupyter-%23FA0F00.svg?style=for-the-badge&logo=jupyter&logoColor=white" style="vertical-align:middle">
</p>

----

This repository contains guide for AILO DGX-A100 Server admin. Every script in this repository can run out-of-the-box with DGX OS installed in the system. If you are running this outside of the DGX OS system, you have to install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/) to use the `--gpus` flag in docker. 

## Prequisites

* NVIDIA GPU
* DGX OS (not mandatory)
* [Docker](https://docs.docker.com/)
* [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/)

## Multi-Instance GPU Configuration
This mig configuration is obtained by dividing the GPU into several parts with [MIG (Multi-Instance GPU)](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html). MIG only work on specific GPU, see supported GPU [here](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html#supported-gpus).

<div align="center">
  
| Size MIG | Availability |
|:----------:|:----------:|
| 1g.5gb | 7 |
| 3g.20gb | 6 |
| 2g.10gb | 0 |
| 7g.40gb | 4 |
  
</div>

Configuration as in the table can be obtained by running the `mig.sh` file:
```
sudo ./mig.sh
```
This MIG partition method can be improved by using [MIG-Parted (MIG Partiton Editor for NVIDIA GPUs)](https://github.com/NVIDIA/mig-parted).

## Running Container

### Build AILO Image
This image is a modified version of the NVIDIA official docker image for [NVIDIA NGC Catalog](https://catalog.ngc.nvidia.com/). The image from this repository can be modified as you please.This image will automatically create a password for jupyter lab and run it after. To build the `Dockerfile`, you can use this command:

```
sudo docker build -t ailo/torch:<image-tag> .
```

### Run Container
This script will create container and a directory (`/raid/dockerv/<username>`) for docker volume (bind). The script will also generate a random password consisting of 12 characters. To run this script, you can use this command:

```
sudo ./run.sh <username> <image:image-tag> <gpu memory> <port> --gpus="device=<MIG UUID>" [additional docker parameters]
```

### Creating Linux User
This script will create a Linux user and generate its public and private keys for authentication. After running this script you will be directed to `id_rsa` file with nano. To run this script, you can use this command:
```
sudo ./create_user.sh <username>
```

### Stop and Remove User's Container, Linux User, and Directory
This script will stop and remove user's container, linux user, and directory (`/raid/dockerv/<username>`). To run this script, you can use this command:

```
sudo ./cleanup.sh <username>
```

## TODO
- [x] Video Tutorial for Admin
- [ ] Video Tutorial for User
- [ ] User Tutorial in AILO Website (need coordination)
- [ ] Create a config file to store currently used GPU
- [ ] Integration with Telkom University Gateway Server (need coordination)

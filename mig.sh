#!/bin/bash

systemctl stop nvsm
systemctl stop nvidia-dcgm
systemctl stop nvidia-fabricmanager
systemctl start nvidia-fabricmanager

nvidia-smi -i 0 -mig 0
nvidia-smi -i 1 -mig 0
nvidia-smi -i 2 -mig 0
nvidia-smi -i 3 -mig 0
nvidia-smi -i 4 -mig 0
nvidia-smi -i 5 -mig 0
nvidia-smi -i 6 -mig 0
nvidia-smi -i 7 -mig 0

nvidia-smi -i 0 -mig 1
nvidia-smi -i 1 -mig 1
nvidia-smi -i 2 -mig 1
nvidia-smi -i 3 -mig 1
nvidia-smi -i 4 -mig 1
nvidia-smi -i 5 -mig 1
nvidia-smi -i 6 -mig 1
nvidia-smi -i 7 -mig 1

nvidia-smi mig -i 0 -cgi 14,14,14,19 -C
nvidia-smi mig -i 1 -cgi 9,9 -C
nvidia-smi mig -i 2 -cgi 9,9 -C
nvidia-smi mig -i 3 -cgi 9,9 -C
nvidia-smi mig -i 4 -cgi 0 -C
nvidia-smi mig -i 5 -cgi 0 -C
nvidia-smi mig -i 6 -cgi 0 -C
nvidia-smi mig -i 7 -cgi 0 -C

systemctl start nvsm
systemctl start nvidia-dcgm
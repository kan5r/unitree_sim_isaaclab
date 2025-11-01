#!/bin/bash

IMAGE_NAME=unitree-sim:latest
CONTAINER_NAME=${USER}-unitree-sim

if ! docker image inspect ${IMAGE_NAME} > /dev/null 2>&1; then
    echo "Docker image ${IMAGE_NAME} not found."
    echo "Please run the following command to build the image:"
    echo "  docker build -f docker/Dockerfile -t ${IMAGE_NAME} ."
    exit 1  
fi


xhost +local:docker
docker run -it --rm \
    --privileged \
    --gpus all \
    --network host \
    -e OMNI_KIT_ACCEPT_EULA=YES \
    -e LIVESTREAM=2 \
    -e ENABLE_CAMERAS=1 \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,video,graphics,display \
    -e LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH \
    -e DISPLAY=$DISPLAY \
    -e VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json \
    -v /etc/vulkan/icd.d:/etc/vulkan/icd.d:ro \
    -v /usr/share/vulkan/icd.d:/usr/share/vulkan/icd.d:ro \
    -v ${PWD}:/home/code/unitree_sim_isaaclab \
    --name ${CONTAINER_NAME} \
    ${IMAGE_NAME} \
    /bin/bash

# python sim_main.py --device cpu --enable_cameras --task Isaac-PickPlace-Cylinder-G129-Dex3-Joint --enable_dex3_dds --robot_type g129
# python sim_main.py --device cpu --enable_cameras --task Isaac-Stack-RgyBlock-G129-Dex3-Joint --enable_dex3_dds --robot_type g129

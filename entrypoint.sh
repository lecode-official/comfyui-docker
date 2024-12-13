#!/bin/bash

# Creates the directories for the models inside of the volume that is mounted from the host
MODEL_DIRECTORIES=(
    "checkpoints"
    "clip"
    "clip_vision"
    "configs"
    "controlnet"
    "diffusers"
    "diffusion_models"
    "embeddings"
    "gligen"
    "hypernetworks"
    "loras"
    "photomaker"
    "style_models"
    "text_encoders"
    "unet"
    "upscale_models"
    "vae"
    "vae_approx"
)
for MODEL_DIRECTORY in ${MODEL_DIRECTORIES[@]}; do
    mkdir -p /opt/comfyui/models/$MODEL_DIRECTORY
done

# Creates the symlink for the ComfyUI Manager to the custom nodes directory, which is also mounted from the host
rm --force /opt/comfyui/custom_nodes/ComfyUI-Manager
ln -s \
    /opt/comfyui-manager \
    /opt/comfyui/custom_nodes/ComfyUI-Manager

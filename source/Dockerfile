
# Defines build arguments for the versions of PyTorch, CUDA, and cuDNN to use
ARG PYTORCH_VERSION=2.12.0
ARG CUDA_VERSION=13.0
ARG CUDNN_VERSION=9

# This image is based on the latest official PyTorch image, because it already contains CUDA, CuDNN, and PyTorch
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime

# Defines build arguments for the versions of ComfyUI and ComfyUI Manager to use
ARG COMFYUI_VERSION=0.22.0

# Installs Git, because ComfyUI and the ComfyUI Manager are installed by cloning their respective Git repositories
RUN apt-get update --assume-yes && \
    apt-get install --assume-yes \
        git \
        sudo \
        libgl1 \
        libglx-mesa0 \
        libglib2.0-0 && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Clones the ComfyUI repository and checks out the latest release
RUN git clone https://github.com/Comfy-Org/ComfyUI.git /opt/comfyui && \
    cd /opt/comfyui && \
    git checkout "v${COMFYUI_VERSION}"

# Removed ComfyUI Manager since it's now bundled with ComfyUI.

# Installs the required Python packages for both ComfyUI and the ComfyUI Manager
RUN pip install --break-system-packages \
    --requirement /opt/comfyui/requirements.txt \
    --requirement /opt/comfyui/manager_requirements.txt

# Sets the working directory to the ComfyUI directory
WORKDIR /opt/comfyui

# Exposes the default port of ComfyUI (this is not actually exposing the port to the host machine, but it is good practice to include it as metadata,
# so that the user knows which port to publish)
EXPOSE 8188

# Adds the startup script to the container; the startup script will create all necessary directories in the models and custom nodes volumes that were
# mounted to the container and symlink the ComfyUI Manager to the correct directory; it will also create a user with the same UID and GID as the user
# that started the container, so that the files created by the container are owned by the user that started the container and not the root user
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

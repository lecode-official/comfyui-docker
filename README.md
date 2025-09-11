# ComfyUI Docker

This is a Docker image for [ComfyUI](https://www.comfy.org/), which makes it extremely easy to run ComfyUI on Linux and Windows WSL2. The image also includes the [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) extension.

## Getting Started

To get started, you have to install [Docker](https://www.docker.com/). This can be either Docker Engine, which can be installed by following the [Docker Engine Installation Manual](https://docs.docker.com/engine/install/) or Docker Desktop, which can be installed by [downloading the installer](https://www.docker.com/products/docker-desktop/) for your operating system.

To enable the usage of NVIDIA GPUs, the NVIDIA Container Toolkit must be installed. The installation process is detailed in the [official documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## Installation

The ComfyUI Docker image is available from the [GitHub Container Registry](https://ghcr.io). Installing ComfyUI is as simple as pulling the image and starting a container, which can be achieved using the following command:

```shell
docker run \
    --name comfyui \
    --detach \
    --restart unless-stopped \
    --env USER_ID="$(id -u)" \
    --env GROUP_ID="$(id -g)" \
    --volume "<path/to/models/folder>:/opt/comfyui/models:rw" \
    --volume "<path/to/custom/nodes/folder>:/opt/comfyui/custom_nodes:rw" \
    --volume "<path/to/output/folder>:/opt/comfyui/output:rw" \
    --publish 8188:8188 \
    --runtime nvidia \
    --gpus all \
    ghcr.io/lecode-official/comfyui-docker:latest
```

Please note, that the `<path/to/models/folder>`, `<path/to/custom/nodes/folder>` and `<path/to/output/folder>` must be replaced with paths to directories on the host system where the models, custom nodes and generated outputs (images, workflows, etc.) will be stored, e.g., `$HOME/.comfyui/models`, `$HOME/.comfyui/custom-nodes` and `$HOME/.comfyui/output`, which can be created like so: `mkdir -p $HOME/.comfyui/{models,custom-nodes,output}`.

The `--detach` flag causes the container to run in the background and `--restart unless-stopped` configures the Docker Engine to automatically restart the container if it stopped itself, experienced an error, or the computer was shutdown, unless you explicitly stopped the container using `docker stop`. This means that ComfyUI will be automatically started in the background when you boot your computer. The two `--env` arguments inject the user ID and group ID of the current host user into the container. During startup, a user with the same user ID and group ID will be created, and ComfyUI will be run using this user. This ensures that files written to the volumes (e.g., models and custom nodes installed with the ComfyUI Manager) will be owned by the host system's user. Normally, the user inside the container is `root`, which means that the files that are written from the container to the host system are also owned by `root`. If you have run ComfyUI Docker without setting the environment variables, then you may have to change the owner of the files in the models and custom nodes directories: `sudo chown -r "$(id -un):$(id -gn)" <path/to/models/folder> <path/to/custom/nodes/folder>`. The `--runtime nvidia` and `--gpus all` arguments enable ComfyUI to access the GPUs of your host system. If you do not want to expose all GPUs, you can specify the desired GPU index or ID instead.

After the container has started, you can navigate to [localhost:8188](http://localhost:8188) to access ComfyUI.

If you want to stop ComfyUI, you can use the following commands:

```shell
docker stop comfyui
docker rm comfyui
```

> [!WARNING]
> While the custom nodes themselves are installed outside of the container, their requirements are installed inside of the container. This means that stopping and removing the container will remove the installed requirements. When the container is started again, the requirements will be automatically installed, but this may, depending on the number of custom nodes and their requirements, take some time.

## Docker Compose

Instead of using `docker run`, you can use the provided `docker-compose.yml` in this repository for easier management and updates.

1. (First time) Create the required host directories:
   ```shell
   mkdir -p $HOME/.comfyui/{models,custom-nodes,output}
   ```
2. (Optional) Create a `.env` file next to `docker-compose.yml` to pin your user / group IDs:
   ```shell
   echo "UID=$(id -u)" > .env
   echo "GID=$(id -g)" >> .env
   ```
   If omitted, the defaults `1000` / `1000` in the compose file are used.
3. Start (or bring up after changes):
   ```shell
   docker compose up -d
   ```
4. View logs:
   ```shell
   docker compose logs -f
   ```
5. Update later:
   ```shell
   docker compose pull
   docker compose up -d
   ```
6. Stop / remove the container (keeps your data in the host directories):
   ```shell
   docker compose down
   ```

Custom CLI arguments: edit the `command:` line in `docker-compose.yml` (uncomment or add) e.g.:
```yaml
command: ["--enable-cors-header", "*"]
```
Then apply changes:
```shell
docker compose up -d --force-recreate
```

Migrating existing outputs from a previously created container (non‑compose):
```shell
docker cp comfyui:/opt/comfyui/output/. $HOME/.comfyui/output/
```

After this, you can remove the old container and strictly use compose.

## Updating

To update ComfyUI Docker to the latest version you have to first stop the running container, then pull the new version, optionally remove dangling images, and then restart the container:

```shell
docker stop comfyui
docker rm comfyui

docker pull ghcr.io/lecode-official/comfyui-docker:latest
docker image prune # Optionally remove dangling images

docker run \
    --name comfyui \
    --detach \
    --restart unless-stopped \
    --env USER_ID="$(id -u)" \
    --env GROUP_ID="$(id -g)" \
    --volume "<path/to/models/folder>:/opt/comfyui/models:rw" \
    --volume "<path/to/custom/nodes/folder>:/opt/comfyui/custom_nodes:rw" \
    --volume "<path/to/output/folder>:/opt/comfyui/output:rw" \
    --publish 8188:8188 \
    --runtime nvidia \
    --gpus all \
    ghcr.io/lecode-official/comfyui-docker:latest
```

If you want to pass additional command line arguments to ComfyUI, you can do so by specifying them as the command when starting the container. For example, if you want to allow external web apps to connect to ComfyUI in the container, you can add the `--enable-cors-header` argument like so:

```shell
docker run \
    --name comfyui \
    --detach \
    --restart unless-stopped \
    --env USER_ID="$(id -u)" \
    --env GROUP_ID="$(id -g)" \
    --volume "<path/to/models/folder>:/opt/comfyui/models:rw" \
    --volume "<path/to/custom/nodes/folder>:/opt/comfyui/custom_nodes:rw" \
    --volume "<path/to/output/folder>:/opt/comfyui/output:rw" \
    --publish 8188:8188 \
    --runtime nvidia \
    --gpus all \
    ghcr.io/lecode-official/comfyui-docker:latest \
    --enable-cors-header <origin>
```

With Docker Compose:
```shell
docker compose up -d --force-recreate
```
(Add or edit the `command:` line in the compose file.)

## Building

If you want to use the bleeding edge development version of the Docker image, you can also clone the repository and build the image yourself:

```shell
git clone https://github.com/lecode-official/comfyui-docker.git
cd comfyui-docker
docker build --tag lecode/comfyui-docker:latest source
```

Now, a container can be started like so:

```shell
docker run \
    --name comfyui \
    --detach \
    --restart unless-stopped \
    --env USER_ID="$(id -u)" \
    --env GROUP_ID="$(id -g)" \
    --volume "<path/to/models/folder>:/opt/comfyui/models:rw" \
    --volume "<path/to/custom/nodes/folder>:/opt/comfyui/custom_nodes:rw" \
    --volume "<path/to/output/folder>:/opt/comfyui/output:rw" \
    --publish 8188:8188 \
    --runtime nvidia \
    --gpus all \
    lecode/comfyui-docker:latest
```

## License

The ComfyUI Docker image is licensed under the [MIT License](LICENSE). [ComfyUI](https://github.com/comfyanonymous/ComfyUI/blob/master/LICENSE) and the [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager/blob/main/LICENSE.txt) are both licensed under the GPL 3.0 license.

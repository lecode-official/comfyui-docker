# Changelog

## v0.2.0 (December 16, 2024)

- Previously, only the model files were stored outside of the container, but the custom nodes installed by ComfyUI Manager were not. The reason was that the ComfyUI Manager itself is implemented as a custom node, which means that mounting a host system directory into the custom nodes directory would hide the ComfyUI Manager. This problem was fixed by installing the ComfyUI Manager in a separate directory and symlinking it upon container startup into the mounted directory.
- Updated the image to the latest version of ComfyUI (from v0.3.4 to v0.3.7).
- In the previous version, the main branch of the ComfyUI Manager was installed and not a specific version. Since the main branch may contain breaking changes or bugs, the ComfyUI Manager is now installed with a specific version (v2.55.5).
- The ComfyUI Manager installs its dependencies when it is first launched. This means that the dependencies have to be installed every time the container is started. To avoid this, the dependencies are now installed manually during the image build process.
- The directory structure of the ComfyUI models directory is now automatically created upon container startup if it does not exist.
- The Docker image now has two more tags: one with the ComfyUI version and the second with the ComfyUI and ComfyUI Manager versions that are installed in the image. This makes it easier for users to find out which ComfyUI version they are installing before pulling the image.
- A section was added to the read me, which explains how to update the local image to the latest version.

## v0.1.0 (November 28, 2024)

- Created a Docker image for running ComfyUI.
- The image includes ComfyUI and ComfyUI Manager.
- The image is based on the latest version of the PyTorch image.
- A GitHub Actions workflow is used to automatically build and publish the Docker image to the GitHub Container Registry when a release is created.

# Changelog

## v0.6.3 (January 9, 2026)

- This is another emergency release to fix an issue in v0.6.2 where the ComfyUI Docker image failed to build, because the build arguments for the versions of ComfyUI and ComfyUI Manager were defined before the `FROM` instruction in the Dockerfile. This only caused an issue now, because the "v" prefix in the ComfyUI version (e.g., "v0.8.2") was removed and then interpolated directly into the `git checkout` command, which led Git to fail with an error stating that the path spec "v" does not exist. The build arguments for the ComfyUI and ComfyUI Manager versions have now been moved to be defined after the `FROM` instruction in the Dockerfile.
- The ComfyUI, ComfyUI Manager, PyTorch, CUDA, and cuDNN versions were not passed as build arguments in the GitHub Actions workflow file when building the Docker image. This has now been fixed by passing the respective `build-args` to the build-push action.
- The tags with only the ComfyUI Docker major version that included the PyTorch, CUDA, and cuDNN versions were accidentally being created, even though the zero version should not have a tag with only the major version. This has now been fixed by adding the necessary condition to the tag creation step in the GitHub Actions workflow file.
- Instead of using `apt`, which does not have a guaranteed stable interface, the `apt-get` command is now used in the Dockerfile to install dependencies. Also, the cached archives are now being removed after installing the packages in addition to the package lists to further reduce the image size.

## v0.6.2 (January 9, 2026)

- This is an emergency release to fix an issue in v0.6.1 where the GitHub Actions workflow did not correctly set the output variable for the version combinations due to a typo in the variable name. This caused the build process to fail when trying to build images for different CUDA and cuDNN versions. The typo has been fixed by changing `version_combinations` to `version-combinations` in the relevant line of the workflow file.

## v0.6.1 (January 9, 2026)

- In order to allow users to choose a specific CUDA version when pulling the image, the Dockerfile was modified to also allow the specification of the PyTorch, CUDA, and cuDNN versions as build arguments. The GitHub Actions workflow was updated to build images for all available combinations of CUDA and cuDNN for the version of PyTorch used in the Dockerfile. The read me was updated to reflect this change.

## v0.6.0 (January 9, 2026)

- Updated the base image of the Dockerfile to the latest version of PyTorch (from PyTorch 2.8.0, CUDA 12.9, and cuDNN 9 to PyTorch 2.9.1, CUDA 12.8, and cuDNN 9).
- Updated the ComfyUI version to the latest version (from ComfyUI 0.3.49 to ComfyUI 0.8.2).
- Updated the ComfyUI Manager version to the latest version (from ComfyUI Manager 3.35 to ComfyUI Manager 4.0.5).
- Updated the versions of the checkout action, Python setup action, and attest build provenance action in the GitHub Actions workflow to their latest versions.
- The outputs of ComfyUI are now stored outside of the container in a directory on the host system. This prevents the loss of outputs when the container is removed. The read me was updated to reflect this change.
- A Docker Compose file was added to the repository to make running, managing, and updating ComfyUI Docker easier. The read me was updated to include instructions on how to use Docker Compose.
- The ComfyUI and ComfyUI Manager repositories are now fully cloned instead of using the `--depth 1` option. Although this increases the size of the image, the size increase is negligible compared to the overall image size. This change now enables users to update ComfyUI and ComfyUI Manager from within the ComfyUI Manager interface, independent of the Docker image version.
- This version of ComfyUI Docker was made possible by the contributions of [Patrick Kranz](@LokiMidgard) and [Alex Marinov](@alex-marinov).

## v0.5.0 (August 12, 2025)

- The ComfyUI Manager repository has been moved to a new organization and therefore, the URL from which it can be cloned has changed. This URL was updated in the Dockerfile.
- It is now possible to pass additional command line arguments to ComfyUI in the `docker run` command. This was done by moving the `CMD` from the Dockerfile to the `entrypoint.sh` script. Now, users can specify additional command line arguments when starting the container as the command, which are then passed to ComfyUI. The read me was updated to showcase this.
- In the read me, the commands for building and running the image locally had a small issue: After cloning the repository, the current directory was not changed to the cloned repository, which would lead to an error when building the image. This was fixed by adding a `cd comfyui-docker` command after the `git clone` command.
- Updated the base image of the Dockerfile to the latest version of PyTorch (from PyTorch 2.7.1, CUDA 12.6, and cuDNN 9 to PyTorch 2.8.0, CUDA 12.9, and cuDNN 9).
- Updated the ComfyUI version to the latest version (from ComfyUI 0.3.40 to ComfyUI 0.3.49).
- Updated the ComfyUI Manager version to the latest version (from ComfyUI Manager 3.33 to ComfyUI Manager 3.35).
- This version of ComfyUI Docker was made possible by the contributions of [Patrick Kranz](@LokiMidgard), [Alex Reynolds](@primlock), and [Mustafa Hamade](@Mustafa-Hamade).

## v0.4.0 (June 16, 2025)

- Updated the base image of the Dockerfile to the latest version of PyTorch (from PyTorch 2.6.0, CUDA 12.4, and cuDNN 9 to PyTorch 2.7.1, CUDA 12.6, and cuDNN 9).
- Updated the ComfyUI version to the latest version (from ComfyUI 0.3.27 to ComfyUI 0.3.40).
- Updated the ComfyUI Manager version to the latest version (from ComfyUI Manager 3.31.8 to ComfyUI Manager 3.33).
- The version numbers of ComfyUI, ComfyUI Manager, and the base image are now stored in arguments in the Dockerfile. This makes it easier to update the image in the future, because the version numbers can be changed in one place at the top of the Dockerfile.
- The ComfyUI and ComfyUI Manager repositories are now cloned with the `--depth 1` option followed by only fetching the specific tag of the specified version, which reduces the size of the image by not including the full commit history.
- Moved the [`Dockerfile`](source/Dockerfile) and the [`entrypoint.sh`](source/entrypoint.sh) script to a new [`source`](source) directory, which is the standard directory for storing source code in Git repositories.
- A [list of contributors to the project](CONTRIBUTORS.md) was added to the repository.
- This version of ComfyUI Docker was made possible by the contributions of [Chris TenHarmsel](@epchris).

## v0.3.0 (March 24, 2025)

- Updated the base image of the Dockerfile to the latest version of PyTorch (from PyTorch 2.5.1, CUDA 12.4, and cuDNN 9 to PyTorch 2.6.0 CUDA 12.4, and cuDNN 9).
- Updated the ComfyUI version to the latest version (from ComfyUI 0.3.7 to ComfyUI 0.3.27).
- Updated the ComfyUI Manager version to the latest version (from ComfyUI Manager 2.55.5 to ComfyUI Manager 3.31.8).
- Installed the packages `libgl1-mesa-glx` and `libglib2.0-0`, which will hopefully fix issues with the ComfyUI Impact Pack, ComfyUI Impact Subpack, and ComfyUI Inspire Pack custom nodes that were missing the `libGL.so.1` and `libgthread-2.0.so.0` libraries.
- The APT cache is now being cleaned after installing the packages to reduce the image size.

## v0.2.0 (December 16, 2024)

- Previously, only the model files were stored outside of the container, but the custom nodes installed by ComfyUI Manager were not. The reason was that the ComfyUI Manager itself is implemented as a custom node, which means that mounting a host system directory into the custom nodes directory would hide the ComfyUI Manager. This problem was fixed by installing the ComfyUI Manager in a separate directory and symlinking it upon container startup into the mounted directory.
- It is now possible to specify the user ID and group ID of the host system user as environment variables when starting the container. During startup, the container will create a user with the same user ID and group ID, and run ComfyUI with this user. This is helpful, because the model and custom node files downloaded by the ComfyUI Manager will be owned by the host system user instead of `root`. The documentation in the read me was updated to reflect this change.
- Updated the image to the latest version of ComfyUI (from v0.3.4 to v0.3.7).
- In the previous version, the main branch of the ComfyUI Manager was installed and not a specific version. Since the main branch may contain breaking changes or bugs, the ComfyUI Manager is now installed with a specific version (v2.55.5).
- The ComfyUI Manager installs its dependencies when it is first launched. This means that the dependencies have to be installed every time the container is started. To avoid this, the dependencies are now installed manually during the image build process.
- While the custom nodes themselves are installed outside of the container, their requirements are installed inside of the container. This means that stopping and removing the container will remove the installed requirements. Therefore, the dependencies are now installed when the container is started again.
- The directory structure of the ComfyUI models directory is now automatically created upon container startup if it does not exist.
- The Docker image now has two more tags: one with the ComfyUI version and the second with the ComfyUI and ComfyUI Manager versions that are installed in the image. This makes it easier for users to find out which ComfyUI version they are installing before pulling the image.
- A section was added to the read me, which explains how to update the local image to the latest version.

## v0.1.0 (November 28, 2024)

- Created a Docker image for running ComfyUI.
- The image includes ComfyUI and ComfyUI Manager.
- The image is based on the latest version of the PyTorch image.
- A GitHub Actions workflow is used to automatically build and publish the Docker image to the GitHub Container Registry when a release is created.

# Alpine docker container image with "headless" VNC/RDP environments

Installed with the following components:

* Desktop environment [**Fluxbox**](http://fluxbox.org)
* xrdp server (default RDP port `3389`)
* vnc server (default VNC port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (default http port `6901`)
* Browsers:
  * Chromium
  * Firefox
  

## Current provided OS & UI sessions:

* `soff/tiny-remote-desktop`: __Alpine with `Fluxbox` UI session__


## Usage

- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access):

      docker run -d -p 5901:5901 -p 6901:6901 soff/tiny-remote-desktop

- Run command with mapping to local port `3389` (rdp protocol):

      docker run -d -p 3389:3389 soff/tiny-remote-desktop

- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access) with access password:

      docker run -d -p 5901:5901 -p 6901:6901 -e VNC_PASSWORD="vncpassword" soff/tiny-remote-desktop

- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access) with specific resolution:

      docker run -d -p 5901:5901 -p 6901:6901 -e RESOLUTION=1600x1200 soff/tiny-remote-desktop

## Automated Builds

This repository uses GitHub Actions to automatically build and push Docker images to Docker Hub.

### How it works:

- **Automatic builds on push**: When code is pushed to `main` or `master` branch, the workflow automatically builds and pushes the image with the `latest` tag
- **Version tagging**: When a version tag (e.g., `v1.0.0`) is pushed, the workflow creates corresponding version tags
- **Manual trigger**: The workflow can also be triggered manually from the Actions tab

### Required Secrets:

To enable automated builds, the following secrets must be configured in the repository settings:

- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token (create one at https://hub.docker.com/settings/security)

## Hints

### 1) No start menu?
Just right click on desktop, the start menu will pop up.

# Tiny Remote Desktop

Alpine-based Docker container with "headless" VNC/RDP remote desktop environments.

## Features

* Desktop environment: [**Fluxbox**](http://fluxbox.org) (lightweight)
* VNC server: **x11vnc** (port `5901`)
* RDP server: **xrdp** (port `3389`)
* Web VNC: [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (port `6901`)
* Browser: **Firefox**
* **Configurable**: Enable/disable services via environment variables
* **Auto-start**: Firefox can auto-launch on startup

## Image Size Optimization

### Current Size: ~300-350MB

The image has been optimized by removing unnecessary packages:
- ❌ **Chromium** (~200MB) - Removed to reduce size
- ❌ **xterm** - Removed (not essential)
- ❌ **bash** - Using Alpine's built-in `sh`
- ❌ **wqy-zenhei** (Chinese fonts) - Removed

### Further Size Reduction

If you need an even smaller image:

1. **Remove Firefox** (~100MB saved):
   ```dockerfile
   # Remove 'firefox' from line 12 in Dockerfile
   # Set AUTOSTART_FIREFOX=false
   # Final size: ~200-250MB
   ```

2. **Remove noVNC** (~10-20MB saved):
   ```dockerfile
   # Remove 'novnc' and 'websockify' from Dockerfile
   # Set ENABLE_NOVNC=false
   ```

3. **VNC-only setup** (~150-200MB):
   ```dockerfile
   # Keep only: xvfb, x11vnc, fluxbox, supervisor
   # Remove: firefox, xrdp, novnc, websockify
   ```

## VNC vs RDP - Which is Faster?

### VNC (Recommended) ✅
- **Faster** for local/LAN connections
- Lower latency and overhead
- Direct connection without additional layers
- **Best choice for this setup**

### RDP
- Better for slow/WAN connections (better compression)
- In this setup, RDP wraps VNC (adds overhead)
- Use VNC directly for better performance

**Verdict**: **VNC is faster** - RDP just adds an extra layer in this configuration.

## Automated Builds

This repository uses GitHub Actions to automatically build and push Docker images to Docker Hub.

### How it works:

- **Automatic builds on push**: When code is pushed to the repository's default branch, the workflow automatically builds and pushes the image with the `latest` tag
- **Version tagging**: When a version tag (e.g., `v1.0.0`) is pushed, the workflow creates corresponding version tags
- **Manual trigger**: The workflow can also be triggered manually from the Actions tab

### Required Secrets:

To enable automated builds, the following secrets must be configured in the repository settings:

- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token (create one at https://hub.docker.com/settings/security)

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `RESOLUTION` | `1024x768` | Screen resolution |
| `VNC_PASSWORD` | (none) | VNC password (optional) |
| `ENABLE_VNC` | `true` | Enable VNC server |
| `ENABLE_RDP` | `true` | Enable RDP server |
| `ENABLE_NOVNC` | `true` | Enable web-based VNC |
| `AUTOSTART_FIREFOX` | `true` | Auto-start Firefox |

### Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 5901 | VNC | Direct VNC access |
| 6901 | HTTP | noVNC web interface |
| 3389 | RDP | Remote Desktop Protocol |

## Usage Examples

### Default Setup (All Services)
```bash
docker run -d \
  -p 5901:5901 \
  -p 6901:6901 \
  -p 3389:3389 \
  --name remote-desktop \
  soff/tiny-remote-desktop
```

Access via:
- VNC client: `localhost:5901`
- Web browser: `http://localhost:6901`
- RDP client: `localhost:3389`

### VNC-Only (Fastest, Smallest)
```bash
docker run -d \
  -p 5901:5901 \
  -e ENABLE_RDP=false \
  -e ENABLE_NOVNC=false \
  --name remote-desktop \
  soff/tiny-remote-desktop
```

### RDP-Only
```bash
docker run -d \
  -p 3389:3389 \
  -e ENABLE_VNC=false \
  -e ENABLE_NOVNC=false \
  --name remote-desktop \
  soff/tiny-remote-desktop
```

### With VNC Password
```bash
docker run -d \
  -p 5901:5901 \
  -p 6901:6901 \
  -e VNC_PASSWORD="vncpassword" \
  --name remote-desktop \
  soff/tiny-remote-desktop
```

### Custom Resolution
```bash
docker run -d \
  -p 5901:5901 \
  -p 6901:6901 \
  -e RESOLUTION=1920x1080 \
  --name remote-desktop \
  soff/tiny-remote-desktop
```

### Without Firefox Auto-Start
```bash
docker run -d \
  -p 5901:5901 \
  -e AUTOSTART_FIREFOX=false \
  --name remote-desktop \
  soff/tiny-remote-desktop
```

## Troubleshooting

### "Another user already login with this id" Error

**Fixed!** This error has been resolved by:
- Adding `-forever` flag to x11vnc
- Proper service startup priorities
- Correct DISPLAY environment configuration

If you still see this error:
1. Ensure only one container instance is running
2. Restart the container: `docker restart <container_name>`
3. Check logs: `docker logs <container_name>`

### RDP Auto-Login

When connecting via RDP:
- Username: `root` (pre-filled)
- Password: (leave empty, press Enter)
- Session: `Xvnc` (pre-selected)
- Just click **OK** or press Enter

For completely password-free access, use VNC directly (port 5901).

### Firefox Auto-Start

Firefox auto-starts when `AUTOSTART_FIREFOX=true` (default).

If Firefox doesn't start:
1. Check logs: `docker logs <container_name>`
2. Start manually from Fluxbox menu (right-click desktop)
3. Verify startup script exists:
   ```bash
   docker exec <container_name> cat /root/.fluxbox/startup
   ```

### No Start Menu?

Right-click anywhere on the desktop to open the Fluxbox menu.

## Building

```bash
docker build -t tiny-remote-desktop .
```

## License

This project does not yet include a formal license file. All rights are reserved by the maintainer unless otherwise stated. Please contact the maintainer for usage permissions.

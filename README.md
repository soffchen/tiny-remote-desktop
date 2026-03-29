# Tiny Remote Desktop

Lightweight headless VNC/RDP desktop environment based on Alpine Edge. Image size ~685MB.

## Components

* Desktop environment: [**Fluxbox**](http://fluxbox.org)
* xRDP server (port `3389`)
* VNC server x11vnc (port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (port `6901`)
* Browser: Firefox
* Chinese font: WenQuanYi Zen Hei

## Usage

Start all services (VNC + noVNC + RDP):

    docker run -d -p 5901:5901 -p 6901:6901 -p 3389:3389 soff/tiny-remote-desktop

With VNC password:

    docker run -d -p 5901:5901 -p 6901:6901 -p 3389:3389 -e VNC_PASSWORD="your_password" soff/tiny-remote-desktop

Custom resolution:

    docker run -d -p 5901:5901 -p 6901:6901 -p 3389:3389 -e RESOLUTION=1600x1200 soff/tiny-remote-desktop

## Connection

| Protocol | Address | Notes |
|----------|---------|-------|
| noVNC (browser) | `http://localhost:6901` | No client needed |
| VNC | `localhost:5901` | Use any VNC client |
| RDP | `localhost:3389` | Use any RDP client |

## Tips

Right-click on desktop to open the application menu.

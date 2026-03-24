FROM alpine:edge

# Add testing repository and update
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    # Install minimal required packages
    apk add --no-cache \
        xvfb \
        x11vnc \
        fluxbox \
        supervisor \
        firefox \
        xrdp \
        novnc \
        websockify && \
    # Clean up
    rm -rf /var/cache/apk/* /tmp/* && \
    # Create noVNC symlink
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html

# Copy configuration files
ADD supervisord.conf /etc/supervisord.conf
ADD xrdp.ini /etc/xrdp/xrdp.ini
ADD menu /root/.fluxbox/menu
ADD entry.sh /entry.sh

RUN chmod +x /entry.sh

# Environment variables
ENV DISPLAY=:0
ENV RESOLUTION=1024x768
ENV ENABLE_VNC=true
ENV ENABLE_RDP=true
ENV ENABLE_NOVNC=true
ENV AUTOSTART_FIREFOX=true

# Expose ports: VNC (5901), noVNC (6901), RDP (3389)
EXPOSE 5901 6901 3389

ENTRYPOINT ["/entry.sh"]

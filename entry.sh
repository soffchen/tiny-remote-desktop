#!/bin/sh

# Configure VNC password if provided
if [ "$VNC_PASSWORD" ]; then
    sed -i "s/^\(command.*x11vnc.*\)$/\1 -passwd '$VNC_PASSWORD'/" /etc/supervisord.conf
fi

# Disable services based on environment variables
if [ "$ENABLE_VNC" != "true" ]; then
    sed -i '/\[program:x11vnc\]/,/^$/d' /etc/supervisord.conf
fi

if [ "$ENABLE_RDP" != "true" ]; then
    sed -i '/\[program:xrdp\]/,/^$/d' /etc/supervisord.conf
fi

if [ "$ENABLE_NOVNC" != "true" ]; then
    sed -i '/\[program:novnc\]/,/^$/d' /etc/supervisord.conf
fi

# Configure Firefox autostart
if [ "$AUTOSTART_FIREFOX" = "true" ]; then
    mkdir -p /root/.fluxbox
    echo "firefox &" > /root/.fluxbox/startup
    echo "exec fluxbox" >> /root/.fluxbox/startup
    chmod +x /root/.fluxbox/startup
fi

exec /usr/bin/supervisord
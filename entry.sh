#!/bin/sh

# Configure VNC password if provided (idempotent using -rfbauth)
if [ "$VNC_PASSWORD" ]; then
    VNC_PASSFILE="/root/.vncpass"
    x11vnc -storepasswd "$VNC_PASSWORD" "$VNC_PASSFILE"
    chmod 600 "$VNC_PASSFILE"
    # Make the change idempotent: remove any existing -passwd or -rfbauth args
    sed -i 's/ -passwd [^ ]*//g; s/ -rfbauth [^ ]*//g' /etc/supervisord.conf
    # Append the auth file option to the x11vnc command
    sed -i "s|^\(command.*x11vnc.*\)$|\1 -rfbauth ${VNC_PASSFILE}|" /etc/supervisord.conf
fi

# Ensure noVNC is not enabled when VNC is disabled
if [ "$ENABLE_NOVNC" = "true" ] && [ "$ENABLE_VNC" != "true" ]; then
    echo "Warning: ENABLE_NOVNC=true requires ENABLE_VNC=true; disabling noVNC."
    ENABLE_NOVNC="false"
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

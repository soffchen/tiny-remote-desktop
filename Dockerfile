FROM alpine:edge

# Install all packages + websockify + noVNC in a single layer, then clean up
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache \
        openssl xvfb x11vnc fluxbox supervisor xterm \
        firefox xrdp wqy-zenhei \
        py3-pip \
    # Install websockify without optional deps (numpy/jwcrypto/redis not needed for VNC proxy)
    && pip install --no-cache-dir --break-system-packages --no-deps websockify \
    # Remove pip after install (not needed at runtime)
    && apk del py3-pip \
    && rm -rf /usr/lib/python3.*/ensurepip \
    # Clean Python bytecode cache
    && find /usr/lib/python3.* -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null; true \
    && find /usr/lib/python3.* -name '*.pyc' -delete 2>/dev/null; true \
    # Remove Python modules not needed at runtime
    && rm -rf /usr/lib/python3.*/site-packages/setuptools* \
              /usr/lib/python3.*/site-packages/packaging* \
              /usr/lib/python3.*/site-packages/pyparsing* \
              /usr/lib/python3.*/test \
              /usr/lib/python3.*/idlelib \
              /usr/lib/python3.*/turtle* \
              /usr/lib/python3.*/venv \
              /usr/lib/python3.*/ensurepip \
              /usr/lib/python3.*/tkinter \
              /usr/lib/python3.*/unittest \
              /usr/lib/python3.*/pydoc* \
              /usr/lib/python3.*/doctest* \
    # Download noVNC and keep only runtime assets
    && wget -qO /tmp/novnc.tar.gz https://github.com/novnc/noVNC/archive/refs/tags/v1.5.0.tar.gz \
    && mkdir -p /usr/share/novnc \
    && tar xzf /tmp/novnc.tar.gz -C /usr/share/novnc --strip-components=1 \
    && rm /tmp/novnc.tar.gz \
    && ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html \
    # Remove noVNC non-runtime files
    && rm -rf /usr/share/novnc/docs \
             /usr/share/novnc/tests \
             /usr/share/novnc/screenshots \
             /usr/share/novnc/snap \
             /usr/share/novnc/.github \
             /usr/share/novnc/package.json \
             /usr/share/novnc/karma.conf.js \
             /usr/share/novnc/po \
             /usr/share/novnc/utils \
    # Clean apk cache, docs, and temp files
    && rm -rf /var/cache/apk/* /tmp/* \
              /usr/share/gtk-doc \
              /usr/share/man \
              /usr/share/doc

ADD supervisord.conf /etc/supervisord.conf
ADD xrdp.ini /etc/xrdp/xrdp.ini
ADD menu /root/.fluxbox/menu
ADD entry.sh /entry.sh

RUN chmod +x /entry.sh

ENV DISPLAY=:0
ENV RESOLUTION=1024x768

EXPOSE 5901 6901 3389

ENTRYPOINT ["/entry.sh"]

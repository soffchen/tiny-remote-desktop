FROM alpine:edge

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add --no-cache openssl xvfb x11vnc fluxbox supervisor xterm bash chromium firefox xrdp wqy-zenhei py3-pip

# websockify/novnc 通过 pip 和手动下载安装（Alpine testing 仓库的版本与 python3.14 不兼容）
RUN pip install --break-system-packages websockify
RUN wget -qO /tmp/novnc.tar.gz https://github.com/novnc/noVNC/archive/refs/tags/v1.5.0.tar.gz && \
    mkdir -p /usr/share/novnc && \
    tar xzf /tmp/novnc.tar.gz -C /usr/share/novnc --strip-components=1 && \
    rm /tmp/novnc.tar.gz && \
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html

ADD supervisord.conf /etc/supervisord.conf
ADD xrdp.ini /etc/xrdp/xrdp.ini
ADD menu /root/.fluxbox/menu
ADD entry.sh /entry.sh

RUN chmod +x /entry.sh

ENV DISPLAY=:0
ENV RESOLUTION=1024x768

EXPOSE 5901 6901

ENTRYPOINT ["/bin/bash", "-c", "/entry.sh"]

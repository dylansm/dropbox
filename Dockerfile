# FROM alpine:latest
FROM frolvlad/alpine-glibc

MAINTAINER Dylan Smith <foliomedia@gmail.com>

USER root

RUN apk update && apk add --no-cache ca-certificates wget glib libstdc++ python \
    && apk add openssl \
    && wget https://www.dropbox.com/download?dl=packages/dropbox.py -O /usr/local/bin/dropbox-cli \
    && addgroup user && adduser -h /home/user -s /bin/sh -D -G user user \
    && mkdir -p /home/user/.dropbox /home/user/Dropbox \
    && cd /home/user && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - \
    && chmod +x /usr/local/bin/dropbox-cli \
    && chown user:user /usr/local/bin/dropbox-cli \
    && chown user:user -R /home/user/ \
    && echo "Installed Dropbox version:" $(cat /home/user/.dropbox-dist/VERSION)

USER user

WORKDIR /home/user/Dropbox

EXPOSE 17500

VOLUME ["/home/user/Dropbox", "/home/user/.dropbox"]

CMD ["/home/user/.dropbox-dist/dropboxd"]

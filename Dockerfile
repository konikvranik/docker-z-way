FROM debian:bullseye-slim

WORKDIR /opt/z-way-server

ENV DEBIAN_FRONTEND=noninteractive

# Block zbw key request
RUN mkdir -p /etc/zbw/flags && touch /etc/zbw/flags/no_connection

RUN dpkg --add-architecture armhf && apt-get update && \
    apt-get install -qqy --no-install-recommends \
    ca-certificates curl \
    wget procps gpg iproute2 openssh-client openssh-server sudo logrotate

RUN sudo dpkg --add-architecture armhf

# Install z-way-server
RUN curl https://storage.z-wave.me/Z-Way-Install | bash
RUN rm -f /opt/z-way-server/automation/storage/*

# Unblock zbw
RUN rm /etc/zbw/flags/no_connection
RUN echo "zbox" > /etc/z-way/box_type

COPY rootfs/ /

# Add the initialization script
RUN chmod +x /opt/z-way-server/run.sh

EXPOSE 8083

CMD /opt/z-way-server/run.sh

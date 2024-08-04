#
# Docker build script that pulls the latest version of Alpine linux, and compiles HoneywellSecurityMQTT to run inside this container.
# Why? So I can run it on OpenWRT, because it lacks the development packages to compile it directly. I'm running a smart home stack
# (Home Assistant + Frigate NVR + Mosquitto MQTT) on Docker on OpenWRT instead of them being separate systems, simply because I can.
#
# Special attention is required to allow the container to access the USB device that is plugged into the host.
# The container needs priviliged access to /dev/bus/usb on the host.
#
# docker run --privileged --name honeywellsecuritymqtt -d <image>

FROM alpine:latest
MAINTAINER Sam Barnes

LABEL Description="Builds HoneywellSecurityMQTT in a container, so I can run this on OpenWRT" Vendor="SamTheGreatCoder" Version="1.0"

#
# First install software packages needed to compile HoneywellSecurityMQTT
#
RUN apk update && apk add git g++ mosquitto-dev librtlsdr-dev

#
# Pull HoneywellSecurityMQTT source code from git, compile it and install it
#
RUN git clone https://github.com/fusterjj/HoneywellSecurityMQTT.git --depth=1

COPY mqtt_config.h /HoneywellSecurityMQTT/src/mqtt_config.h

RUN cd /HoneywellSecurityMQTT/src && ./build.sh

#
# When running a container this script will be executed
#
ENTRYPOINT ["./HoneywellSecurityMQTT/src/honeywell"]

#
# This is the Dockerfile for macchina.io EDGE
#

#
# Stage 1: Build
#
FROM ubuntu:20.04 AS buildstage

# Install required components for building
RUN apt-get -y update \
 && apt-get -y install \
	g++ \
	git \
	libssl-dev \
	make \
	python2

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1

# Create user
RUN adduser --system --group build

# Setup Directories
RUN mkdir -p /home/build/source \
	&& mkdir -p /home/build/install \
	&& chown -R build:build /home/build

USER build:build
WORKDIR /home/build

# Fetch macchina.io EDGE Sources
RUN cd /home/build/source \
	&& git clone https://github.com/macchina-io/macchina.io.git

# Build macchina.io EDGE
RUN cd /home/build/source/macchina.io \
	&& make -s -j8 DEFAULT_TARGE=shared_release PRODUCT=runtime -j`nproc` \
	&& make PRODUCT=runtime INSTALLDIR=/home/build/install install

#
# Stage 2: Install
#
FROM ubuntu:20.04 AS runstage

RUN apt-get -y update \
 && apt-get -y install \
    libssl1.1 \
    ca-certificates

# Copy macchina.io EDGE
RUN mkdir -p /opt/macchina \
 && mkdir -p /opt/macchina/var/lib \
 && mkdir -p /opt/macchina/var/log \
 && mkdir -p /opt/macchina/var/cache/bundles

COPY --from=buildstage /home/build/install /opt/macchina
ADD macchina.properties /opt/macchina/etc/macchina.properties

# Create user (note: membership in dialout group is required for access to serial ports,
# including certain USB devices). We also add the gpio group for access to GPIOs on
# a Raspberry Pi (NOTE: for access to GPIOs (/sys/class/gpio files), the container
# must be run in privileged mode).
RUN adduser --system --group macchina \
 && addgroup --system --gid 997 gpio \
 && adduser macchina dialout \
 && adduser macchina gpio

RUN chown -R macchina:macchina /opt/macchina
USER macchina

ENV HTTP_PORT=22080
ENV HTTPS_PORT=0
ENV TLS_SERVER_CERT=/opt/macchina/etc/macchina.pem
ENV TLS_SERVER_KEY=/opt/macchina/etc/macchina.pem
ENV LOGPATH=/opt/macchina/var/log/macchina.log
ENV LOGLEVEL=information
ENV LOGCHANNEL=console
ENV ADMIN_PASSWORD_HASH=6647921ab0216b5ed98d0d36bb621945
ENV USER_PASSWORD_HASH=41d3d2ef29df3a55d6eb8d4fd4ca3624

ENV LD_LIBRARY_PATH=/opt/macchina/lib:/opt/macchina/var/cache/bundles

VOLUME /opt/macchina/var/log
VOLUME /opt/macchina/var/lib

CMD ["/opt/macchina/bin/macchina", "--config=/opt/macchina/etc/macchina.properties"]

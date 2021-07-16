# Dockerfile for macchina.io EDGE

This repository contains a Dockerfile and related files for building
a Docker image with [macchina.io EDGE](https://https://github.com/macchina-io/macchina.io),
based on Ubuntu 20.04.

## Build

To build this image locally, run the following command (with `docker-compose` installed):

```
$ docker-compose build
```

or directly by running `docker`:

```
$ docker build . -t macchina/edge-ce:ubuntu
```

## Run

To start a macchina.io EDGE container locally, you can execute:

    $ docker-compose up -d

or directly by docker:

    $ docker run -p 22080:22080 macchina/edge-ce:ubuntu

Both commands bind port 22080 from docker container to port 22080 on host, so the
web interface is available at http://localhost:22080

### Accessing Devices

Serial devices and USB devices implementing a virtual serial port can be accessed from
the container by exposing the device to the container when creating it:

```
   $ docker run -p 22080:22080 --device=/dev/ttyACM0 macchina/edge-ce:ubuntu
```

In the above example, the device `/dev/ttyACM0` will be available to macchina.io EDGE
in the container. Note: on some devices it may also be necessary to add the `macchina`
user in the container to a specific group in order to be able to access that device.
On most systems, it is the `dialout` group, and the `Dockerfile` already adds the `macchina`
user to that group. If another group is required, the `Dockerfile` must be changed.

To access Linux GPIO devices (via `/sys/class/gpio`, as implemented in the macchina.io EDGE
Linux GPIO support), the container must be run in privileged mode:

```
   $ docker run -p 22080:22080 --privileged macchina/edge-ce
```

The `Dockerfile` creates the `gpio` group (997), in order for GPIO support to work
on a Raspberry Pi, and adds the `macchina` user to that group. For other devices,
this may have to be changed in the `Dockerfile`.

The necessary configuration settings for enable certain devices can be made in the
*Settings* app in the macchina.io EDGE web interface. After adding or changing the
necessary configuration properties, don't forget to save the configuration and
restart the affected bundles for the configuration changes to take effect.

### Configuration

Some configuration settings can be changed via environment variables. The
following environment variables can be set:

  - `HTTP_PORT`: Port number of the macchina.io EDGE web server (default: `22080`)
  - `HTTPS_PORT`: Port number of the macchina.io EDGE secure (HTTPS) web server (default: `22443`)
  - `TLS_SERVER_CERT`: Path to X509 certificate file in PEM format for secure web server (default: `/opt/macchina/etc/macchina.pem`)
  - `TLS_SERVER_KEY`: Path to certificate private key file (default: `/opt/macchina/etc/macchina.pem`)
  - `LOGPATH`: Path of log file (default: `/opt/macchina/var/log/macchina.log`)
  - `LOGLEVEL`: Log level (`debug`, `information`, `notice`, `warning`, `error`, `critical`, `fatal`, `none`; default: `information`)
  - `LOGCHANNEL`: Default log channel (`console` or `file`; default: `console`)
  - `ADMIN_PASSWORD_HASH`: MD5 hash of `edgeadmin` account password
  - `USER_PASSWORD_HASH`: MD5 hash of `edgeuser` account password

Note: you can generate the MD5 password hash with the following command:

```
$ echo -n "password" | md5sum
```

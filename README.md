# Dockerfile for macchina.io EDGE

This repository contains a Dockerfile and related files for building
a Docker image with [macchina.io EDGE](https://https://github.com/macchina-io/macchina.io).

## Build

To build this image locally, run the following command:

    $ docker-compose build

or directly by docker:

    $ docker build . -t macchina/edge-ce

## Run

To start a macchina.io EDGE container locally, you can execute:

    $ docker-compose up -d

or directly by docker:

    $ docker run -p 22080:22080 macchina/edge-ce

Both commands bind port 22080 from docker container to port 22080 on host, so the
web interface is available at http://localhost:22080

Some configuration settings can be changed via environment variables. The
following environment variables can be set:

  - `HTTP_PORT`: Port number of the macchina.io EDGE web server (default: `22080`)
  - `HTTPS_PORT`: Port number of the macchina.io EDGE secure (HTTPS) web server (default: `22443`)
  - `TLS_SERVER_CERT`: Path to X509 certificate file in PEM format for secure web server (default: `/opt/macchina/etc/macchina.pem`)
  - `TLS_SERVER_KEY`: Path to certificate private key file (default: `/opt/macchina/etc/macchina.pem`)
  - `LOGPATH`: Path of log file (default: `/opt/macchina/var/log/macchina.log`)
  - `LOGLEVEL`: Log level (`debug`, `information`, `notice`, `warning`, `error`, `critical`, `fatal`, `non`; default: `information`)
  - `LOGCHANNEL`: Default log channel (`console` or `file`; default: `console`)
  - `ADMIN_PASSWORD_HASH`: MD-5 hash of `edgeadmin` account password
  - `USER_PASSWORD_HASH`: MD-5 hash of `edgeuser` account password

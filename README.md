[![Build Status](https://travis-ci.org/macchina-io/meta-docker.svg?branch=master)](https://travis-ci.org/macchina-io/meta-docker)
# Macchina.io Meta Docker

## Docker image script for [macchina.io](https://github.com/macchina-io/macchina.io)

You can use this image directly in your project or with the macchina.io project.

The image is uploaded to Dockerhub: [macchinaio/macchina.io](https://hub.docker.com/r/macchinaio/macchina.io/)

## Build

You can also build the image locally:

    $ docker-compose build

or directly by docker:

    $ docker build . -t macchinaio/macchina.io

## Run

To start a container locally, you can execute:

    $ docker-compose up -d

or directly by docker:

    $ docker run -t -d --name macchina.io -p 22080:22080 macchina/macchina.io

Both commands bind port 22080 from docker container to port 22080 on host.

## Status

To get current container status, you can execute:

    $ docker-compose ps

or directly by docker:

    $ docker ps

Both commands will show macchina.io container state.

## License
The [LICENSE](LICENSE) is under Apache License Version 2.0

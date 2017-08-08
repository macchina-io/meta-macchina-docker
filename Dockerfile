FROM gcc:5.4

LABEL maintainer="Günter Obiltschnig"

RUN git clone --branch master https://github.com/macchina-io/macchina.io.git /opt/macchina.io \
    && make -s -j4 -C /opt/macchina.io DEFAULT_TARGET=shared_release

ENV LD_LIBRARY_PATH /opt/macchina.io/platform/lib/Linux/x86_64

CMD ["/opt/macchina.io/server/bin/Linux/x86_64/macchina"]

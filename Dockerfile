FROM ubuntu

EXPOSE 80

ENV VERSION 5.0.0
ENV PORT 80
ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      64m
ENV PARAMS -p default_ttl=0 -p default_grace=1800 -p default_keep=10


ADD start.sh /start.sh
ADD default.vcl /etc/varnish/default.vcl

RUN apt-get update \
    && apt-get -y install binutils cpp cpp-5 gcc gcc-5 libasan2 \
    libatomic1 libbsd0 libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libedit2 libgcc-5-dev \
    libgmp10 libgomp1 libisl15 libitm1 libjemalloc1 liblsan0 libmpc3 libmpfr4 libmpx0 \
    libquadmath0 libtsan0 libubsan0 libvarnishapi1 linux-libc-dev manpages manpages-dev \
    && apt-get -y install wget \
    && wget https://repo.varnish-cache.org/pkg/5.0.0/varnish_5.0.0-1_amd64.deb \
    && dpkg -i varnish_5.0.0-1_amd64.deb \
    && rm varnish_5.0.0-1_amd64.deb \
    && apt-get autoremove wget \
    && apt-get clean \
    && chmod +x start.sh

CMD ["/start.sh"]

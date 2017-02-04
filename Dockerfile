FROM alpine:3.4

EXPOSE 80

ENV VERSION 5.0.0
ENV PORT 80
ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      64m
ENV PARAMS -p default_ttl=0 -p default_grace=1800 -p default_keep=10

# See http://git.alpinelinux.org/cgit/aports/tree/main/varnish/musl-mode_t.patch
ADD mode_t.patch /

ADD start.sh /start.sh
ADD default.vcl /etc/varnish/default.vcl

# See https://www.varnish-cache.org/docs/trunk/installation/install.html
RUN apk add --no-cache pcre g++ \
    && apk add --no-cache --virtual .build-deps autoconf automake libtool libedit-dev linux-headers make ncurses-dev pcre-dev python \
    && wget http://repo.varnish-cache.org/source/varnish-$VERSION.tar.gz \
    && tar xf varnish-$VERSION.tar.gz \
    && cd varnish-$VERSION \
    && ./autogen.sh \
    && ./configure --with-rst2man=/bin/true \
    && patch -p1 < /mode_t.patch \
    && make \
    && make install \
    && cd .. \
    && rm -r varnish-$VERSION.tar.gz varnish-$VERSION \
    && rm /mode_t.patch \
    && apk del .build-deps \
    && chmod +x start.sh

CMD ["/start.sh"]

FROM alpine:3.4

ENV VARNISH_VERSION 5.0.0

# See http://git.alpinelinux.org/cgit/aports/tree/main/varnish/musl-mode_t.patch
ADD mode_t.patch /

# See https://www.varnish-cache.org/docs/trunk/installation/install.html
RUN apk add --no-cache pcre g++ \
    && apk add --no-cache --virtual .build-deps autoconf automake libtool libedit-dev linux-headers make ncurses-dev pcre-dev python \
    && wget http://repo.varnish-cache.org/source/varnish-$VARNISH_VERSION.tar.gz \
    && tar xf varnish-$VARNISH_VERSION.tar.gz \
    && cd varnish-$VARNISH_VERSION \
    && ./autogen.sh \
    && ./configure --with-rst2man=/bin/true \
    && patch -p1 < /mode_t.patch \
    && make \
    && make install \
    && cd .. \
    && rm -r varnish-$VARNISH_VERSION.tar.gz varnish-$VARNISH_VERSION \
    && rm /mode_t.patch \
    && apk del .build-deps

FROM alpine

EXPOSE 80

ENV VERSION 4.1.3
ENV PORT 80
ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      64m
ENV PARAMS -p default_ttl=0 -p default_grace=1800 -p default_keep=10


ADD start.sh /start.sh

RUN apk add --no-cache varnish
    && chmod +x start.sh

CMD ["/start.sh"]

FROM alpine:3.12

RUN apk add --no-cache bash=5.0.17-r0
RUN apk add --no-cache perl=5.30.3-r0

# Copy repository contents into iamge
RUN mkdir -p /scriptit
WORKDIR /scriptit
COPY templates /scriptit/templates
COPY utils /scriptit/utils
COPY scriptit.sh /scriptit/scriptit.sh
RUN chmod 755 /scriptit/scriptit.sh

# Add entrypoint
COPY deploy/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ /scriptit/scriptit.sh ]
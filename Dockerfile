FROM alpine:3.12

RUN apk add --no-cache bash=5.0.17-r0
RUN apk add --no-cache perl=5.30.3-r0

# Add default user
RUN addgroup -g 1000 onescriptkid
RUN adduser -D -u 1000 -G onescriptkid -s /bin/bash onescriptkid

# Copy repository contents into iamge
RUN mkdir -p /scriptit
WORKDIR /scriptit
COPY templates /scriptit/templates
COPY utils /scriptit/utils
COPY scriptit.sh /scriptit/scriptit.sh

# Add entrypoint
COPY deploy/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Grant exec
RUN chmod 755 /scriptit/scriptit.sh
ENV PATH="/scriptit:${PATH}"
USER onescriptkid
CMD [ "/scriptit/scriptit.sh" ]

FROM alpine:3.12

RUN apk add --no-cache bash=5.0.17-r0

# Add default user
RUN addgroup -g 1000 onescriptkid
RUN adduser -D -u 1000 -G onescriptkid -s /bin/bash onescriptkid

# Copy repository contents into iamge
RUN mkdir -p /madlib
WORKDIR /madlib
COPY templates /madlib/templates
COPY utils /madlib/utils
COPY madlib.sh /madlib/madlib.sh
COPY mo /madlib/mo
RUN chmod 755 ./mo
RUN chown 1000:1000 -R /madlib

# Add entrypoint
COPY deploy/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Grant exec
RUN chmod 755 /madlib/madlib.sh
ENV PATH="/madlib:${PATH}"
USER onescriptkid
CMD [ "/madlib/madlib.sh" ]

ARG ZOTONIC_VERSION=0.x
FROM zotonic/zotonic:${ZOTONIC_VERSION}

ADD . /opt/ginger
COPY docker/prod/etc_zotonic /etc/zotonic

WORKDIR /opt/zotonic

RUN apk add --virtual build-deps --no-cache $BUILD_APKS \
	&& apk add --no-cache s6 bash \
	&& DEBUG=1 JSX_FORCE_MAPS=1 make \
	&& apk del build-deps

RUN chown -R zotonic /opt/ginger

COPY docker/prod/s6 /etc/s6

CMD s6-svscan /etc/s6

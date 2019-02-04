FROM alpine:edge

LABEL maintainer "Dean Camera <http://www.fourwalledcubicle.com>"

RUN mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data && \
	apk add --no-cache tzdata bash aria2 darkhttpd s6

RUN	apk add --no-cache --virtual .install-deps curl unzip \
	&& mkdir -p /aria2-webui \
	&& curl -o /aria2-webui.zip -L https://github.com/ziahamza/webui-aria2/archive/4c3d2fddc9e2aec0137fbd7f26ed710678a39c7c.zip \
	&& unzip /aria2-webui.zip -d /aria2-webui \
	&& mv /aria2-webui/webui-aria2-4c3d2fddc9e2aec0137fbd7f26ed710678a39c7c/* /aria2-webui \
	&& rm -rf /aria2-webui/webui-aria2-4c3d2fddc9e2aec0137fbd7f26ed710678a39c7c \
	&& rm /aria2-webui.zip \
	&& apk del .install-deps

ADD files/start.sh /conf-copy/start.sh
ADD files/aria2.conf /conf-copy/aria2.conf

RUN chmod +x /conf-copy/start.sh

WORKDIR /

VOLUME ["/data"]
VOLUME ["/conf"]

EXPOSE 6800
EXPOSE 80

CMD ["/conf-copy/start.sh"]

FROM elixir:1.10.2-alpine
MAINTAINER Conor Devine <conorjdevine@gmail.com>

RUN apk update \
	&& apk add nodejs=12.15.0-r1 \
	&& apk add npm \
	&& apk add inotify-tools

ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN addgroup -g $APP_GROUP_ID -S $APP_GROUP && \
	adduser -S -s /sbin/nologin -u $APP_USER_ID -G $APP_GROUP $APP_USER && \
	mkdir /app && \
	chown $APP_USER:$APP_GROUP /app

WORKDIR /app
USER $APP_USER

RUN mix local.hex --force \
	&& mix archive.install --force hex phx_new 1.4.16 \
	&& mix local.rebar --force

EXPOSE 4000

CMD ["mix", "phx.server"]

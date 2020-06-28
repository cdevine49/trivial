FROM elixir:1.10.2-alpine
MAINTAINER Conor Devine <conorjdevine@gmail.com>

RUN apk add --no-cache nodejs=12.15.0-r1 \
	npm=12.15.0-r1 \
	bash=5.0.11-r1 \
	chromium=81.0.4044.113-r0 \
	chromium-chromedriver=81.0.4044.113-r0 \
	inotify-tools=3.20.1-r1

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

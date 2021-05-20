FROM ruby:2.5.0-alpine

WORKDIR /app

COPY ./code .

RUN apk update && apk add --no-cache \
  build-base \
  mariadb-dev \
  mariadb-client \
  nodejs \
  tzdata \
  shared-mime-info \
  && rm -fr /tmp/* /var/cache/apk/*

RUN bundle

RUN echo "Europe/Moscow" > /etc/timezone

ENTRYPOINT  bundle exec ruby backup_daemon/run.rb >> log/backup_daemon.log

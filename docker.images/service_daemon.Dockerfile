FROM ruby:2.6.0-alpine

WORKDIR /app

COPY ./code/Gemfile* ./

RUN apk update && apk add --no-cache \
  build-base \
  mariadb-dev \
  nodejs \
  tzdata \
  shared-mime-info \
  && rm -fr /tmp/* /var/cache/apk/*

RUN bundle

RUN echo "Europe/Moscow" > /etc/timezone

ENTRYPOINT  bundle exec ruby service_daemon/run.rb >> log/service_daemon.log

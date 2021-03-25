FROM ruby:2.5.0-alpine

WORKDIR /app

COPY ./code .

RUN apk update && apk add --no-cache \
  build-base \
  mariadb-dev \
  nodejs \
  tzdata \
  && rm -fr /tmp/* /var/cache/apk/*

RUN bundle

RUN echo "Europe/Moscow" > /etc/timezone

ENTRYPOINT  bundle exec ruby bot/run.rb >> log/bot.log

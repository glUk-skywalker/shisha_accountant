FROM ruby:2.5.0-alpine

ENV RAILS_ENV development

WORKDIR /app

COPY ./code .

RUN apk update && apk add --no-cache \
  build-base \
  mariadb-dev \
  nodejs \
  tzdata \
  shared-mime-info \
  && rm -fr /tmp/* /var/cache/apk/*

RUN bundle

RUN echo "Europe/Moscow" > /etc/timezone

EXPOSE 3000

ENTRYPOINT [ "bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000" ]

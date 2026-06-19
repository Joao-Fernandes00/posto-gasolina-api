# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.8
FROM ruby:${RUBY_VERSION}-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl libjemalloc2 libpq-dev libyaml-dev pkg-config postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_PATH="/usr/local/bundle"

COPY Gemfile* ./
RUN bundle install

COPY . .

ENTRYPOINT ["/app/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]

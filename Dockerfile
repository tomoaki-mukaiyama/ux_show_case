FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /rails_api
WORKDIR /rails_api

COPY Gemfile /rails_api/Gemfile
COPY Gemfile.lock /rails_api/Gemfile.lock

RUN gem install bundler
RUN bundle install
COPY . /rails_api
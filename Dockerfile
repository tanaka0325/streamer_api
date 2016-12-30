FROM ruby:2.3.3

RUN /bin/cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV APP_ROOT /usr/src/streamer
WORKDIR $APP_ROOT

RUN apt-get update -qq && \
    apt-get install -y nodejs \
                     mysql-client \
                     build-essential \
                     --no-install-recommends

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod uog+r /etc/gemrc && \
    gem update --system && \
    gem update

RUN bundle config --global build.nokogiri --use-system-libraries && \
    bundle config --global jobs 4 && \
    bundle install && \
    rm -rf ~/.gem

COPY . $APP_ROOT

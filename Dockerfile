FROM ruby:3.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

# https://github.com/jtoy/cld/issues/10
RUN env CFLAGS=-Wno-narrowing CXXFLAGS=-Wno-narrowing bundle install

COPY . .

RUN rm "/usr/src/app/config.yml"
RUN ln -s "/config.yml" "/usr/src/app/config.yml"

VOLUME ["/config.yml"]

CMD ["ruby", "yossarian-bot.rb"]

FROM ruby:2.6.6
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       nodejs
RUN mkdir /webapp
WORKDIR /webapp
COPY Gemfile /webapp/Gemfile
COPY Gemfile.lock /webapp/Gemfile.lock
RUN bundle install
COPY . /webapp

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
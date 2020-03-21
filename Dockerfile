# use ruby version 2.6.5
FROM ruby:2.6.5

# using japanese on rails console
ENV LANG C.UTF-8

# remove warn
ENV DEBCONF_NOWARNINGS yes
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE yes
ENV XDG_CACHE_HOME /tmp
EXPOSE 3000

# install package to docker container
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    vim \
    less \
    graphviz

# install yarn
RUN apt-get install apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

## setting work directory
#RUN mkdir -p /tmp
#WORKDIR /tmp
#ADD Gemfile Gemfile
#ADD Gemfile.lock Gemfile.lock
#RUN bundle install

# setting environment value
ENV HOME /app
RUN mkdir -p /app
WORKDIR $HOME
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
COPY . $HOME

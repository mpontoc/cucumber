FROM ruby:2.3

MAINTAINER Cleber Braz <mpontoc@hotmail.com>

RUN mkdir /app
WORKDIR /app

RUN gem update
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install
RUN apt-get update && apt-get install -y --fix-missing iceweasel xvfb

ENV   GECKODRIVER_VERSION v0.13.0
RUN   mkdir -p /opt/geckodriver_folder
RUN   wget -O /tmp/geckodriver_linux64.tar.gz https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz
RUN   tar xf /tmp/geckodriver_linux64.tar.gz -C /opt/geckodriver_folder
RUN   rm /tmp/geckodriver_linux64.tar.gz
RUN   chmod +x /opt/geckodriver_folder/geckodriver
RUN   ln -fs /opt/geckodriver_folder/geckodriver /usr/local/bin/geckodriver

ADD features /app/features
ADD cucumber-command.sh /app/cucumber-command.sh
RUN chmod a+x /app/cucumber-command.sh

CMD xvfb-run --server-args="-screen 0 1440x900x24" bash cucumber-command.sh

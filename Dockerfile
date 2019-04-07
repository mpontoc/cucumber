
FROM ruby:2.5

MAINTAINER Cleber Braz <mpontoc@hotmail.com>

ENV app /opt/cucumber_google/
ENV DEBIAN_FRONTEND noninteractive
ENV CHROMIUM_DRIVER_VERSION 2.40
WORKDIR ${app}

COPY Gemfile* ${app}

RUN apt-get update

# We need wget to set up the PPA and xvfb to have a virtual screen and unzip to install the Chromedriver test
RUN apt-get install -y wget xvfb unzip

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install chrome
RUN apt-get update -y
# Install dependencies & Chrome
RUN apt-get update && apt-get -y --no-install-recommends install zlib1g-dev liblzma-dev wget xvfb unzip libgconf2-4 libnss3 nodejs \
 && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -  \
 && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
 && apt-get update && apt-get -y --no-install-recommends install google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

# Install Chrome driver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMIUM_DRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ \
    && rm /tmp/chromedriver.zip \
&& chmod ugo+rx /usr/bin/chromedriver

# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH

# Autorun chrome headless with no GPU
ENTRYPOINT ["chromium-browser", "--headless", "--disable-gpu", "--disable-software-rasterizer", "--disable-dev-shm-usage"]

RUN apt-get update && apt-get install -y --fix-missing iceweasel xvfb unzip

ENV   GECKODRIVER_VERSION v0.13.0
RUN   echo $GECKODRIVER_VERSION
RUN   mkdir -p /opt/geckodriver_folder
RUN   wget -O /tmp/geckodriver_linux64.tar.gz https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz
RUN   tar xf /tmp/geckodriver_linux64.tar.gz -C /opt/geckodriver_folder
RUN   rm /tmp/geckodriver_linux64.tar.gz
RUN   chmod +x /opt/geckodriver_folder/geckodriver
RUN   ln -fs /opt/geckodriver_folder/geckodriver /usr/local/bin/geckodriver

RUN gem install bundler \
&& bundle install

#gerar resuldo dotnet vsts
RUN dotnet restore
RUN dotnet build -c Release
RUN dotnet test dotnetcore-tests/dotnetcore-tests.csproj -c Release --logger "trx;LogFileName=testresults.trx"
RUN dotnet publish -c Release -o out
ENTRYPOINT dotnet dotnetcore-sample/out/dotnetcore-sample.dll

COPY . ${app}

ENTRYPOINT ["bundle", "exec", "cucumber -f pretty -f json -o cucumber.json -o cucumber.xml", "dotnet", "dotnetcore-sample.dll"]

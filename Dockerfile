FROM ubuntu:18.04
MAINTAINER gadomski.kr@gmail.com

RUN apt-get update
RUN apt-get install curl git -y

# setup worker

RUN mkdir /actions-runner
WORKDIR /actions-runner
RUN curl -O https://githubassets.azureedge.net/runners/2.161.0/actions-runner-linux-x64-2.161.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.161.0.tar.gz
RUN ./bin/installdependencies.sh


RUN useradd -ms /bin/bash touk-worker
RUN chown -R touk-worker:touk-worker /actions-runner

RUN apt-get install -y gnupg2
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add -

RUN apt-get install -y nodejs 
RUN apt-get install wget -y
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update
RUN apt-get install -y google-chrome-stable sbt
RUN echo "CHROME_BIN=/usr/bin/google-chrome" | tee -a /etc/environment

RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common openjdk-8-jdk

RUN    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/microsoft-prod.list
RUN    apt-get update
RUN    apt-get install -y moby-engine moby-cli

RUN apt-get install -y npm 

RUN usermod -aG docker touk-worker

RUN echo "if [ -e /var/run/docker.sock ]; then chown touk-worker:touk-worker /var/run/docker.sock; fi" >> /home/touk-worker/.bashrc
USER touk-worker
WORKDIR /actions-runner


COPY entrypoint.sh /actions-runner

#ENTRYPOINT ["/actions-runner/entrypoint.sh"]

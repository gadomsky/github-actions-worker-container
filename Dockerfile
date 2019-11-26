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

USER touk-worker
WORKDIR /actions-runner

COPY entrypoint.sh /actions-runner

ENTRYPOINT ["/actions-runner/entrypoint.sh"]

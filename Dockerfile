FROM ubuntu:14.04
MAINTAINER jerome.petazzoni@docker.com

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    lxc \
    iptables > /dev/null
    
# Install Docker from Docker Inc. repositories.
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 \
  && apt-get update -qq \
  && apt-get install -qqy lxc-docker > /dev/null

ENV VER 9

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
ADD ./run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/run.sh

# Put logging to log file
ENV LOG file

# Define additional metadata for our image.
VOLUME /var/lib/docker
ENTRYPOINT ["wrapdocker"]


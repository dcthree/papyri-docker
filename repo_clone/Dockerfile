FROM ubuntu:xenial
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install the Ubuntu packages.
RUN echo deb-src http://archive.linux.duke.edu/ubuntu/ trusty main >> /etc/apt/sources.list
# Install Git
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -y git subversion wget locales build-essential

# Set the locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ADD . /root/
HEALTHCHECK --retries=9999 CMD /root/check_repo.sh
CMD /root/clone_repo.sh

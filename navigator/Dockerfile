FROM ubuntu:xenial
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install Git
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -y git subversion wget locales build-essential maven openjdk-8-jdk curl

# Set the locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LEIN_ROOT true

RUN git clone --branch v2.0-rc1 --single-branch https://github.com/DCLP/navigator.git /navigator

ADD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein /usr/local/bin/lein
RUN chmod a+x /usr/local/bin/lein
ADD . /root
HEALTHCHECK --retries=9999 CMD /root/mapping-done.sh
CMD /root/run-mapping.sh

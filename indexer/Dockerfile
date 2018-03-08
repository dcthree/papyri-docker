FROM ubuntu:xenial
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install Git
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -y git subversion wget locales build-essential maven openjdk-8-jdk curl strace

# Set the locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LEIN_ROOT true

RUN git clone --branch master --single-branch https://github.com/DCLP/epidoc-xslt.git /epidoc-xslt

ADD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein /usr/local/bin/lein
RUN chmod a+x /usr/local/bin/lein
ADD . /root
HEALTHCHECK --retries=9999999 CMD /root/check_indexing.sh
CMD /root/run-indexing.sh

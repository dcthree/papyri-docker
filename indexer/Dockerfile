FROM ubuntu:focal
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# arguments passed to the clojure indexer script
ARG INDEXING_ARGS="lein run biblio && lein run load-lemmas && lein run"

# Install Git
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -y git subversion wget locales build-essential maven openjdk-11-jdk curl strace

# Set the locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LEIN_ROOT true

ADD https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein /usr/local/bin/lein
RUN chmod a+x /usr/local/bin/lein
ADD . /root
RUN sed -i "s/lein run biblio && lein run load-lemmas && lein run/$INDEXING_ARGS/g" /root/run-indexing.sh
CMD /root/run-indexing.sh

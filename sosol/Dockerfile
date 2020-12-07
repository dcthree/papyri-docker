FROM ryanfb/sosol
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

RUN apt-get update && apt-get install -y inotify-tools

ADD . /root/sosol/
HEALTHCHECK --retries=9999 CMD /root/sosol/warble-done.sh
CMD /root/sosol/migrate-and-copy.sh

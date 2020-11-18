FROM ryanfb/sosol
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

ADD . /root/sosol/
HEALTHCHECK --retries=9999 CMD /root/sosol/warble-done.sh
CMD /root/sosol/migrate-and-copy.sh

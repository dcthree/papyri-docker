#!/bin/bash

if [ -e "/srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war" ]; then
  cp /srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war /usr/local/tomcat/webapps/
  catalina.sh run
  exit 0
else
  exit 1
fi

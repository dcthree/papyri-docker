#!/bin/bash

WAIT_LOCK="/srv/data/papyri.info/lockfiles/navigator/mapping_done.lock"
echo "waiting for ${WAIT_LOCK}"
until [ -e "${WAIT_LOCK}" ]; do
  sleep 1
done
echo "${WAIT_LOCK} detected"

if [ -e "/srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war" ]; then
  cp -v /srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war /usr/local/tomcat/webapps/dispatch.war
  cp -v /srv/data/papyri.info/git/navigator/pn-sync/target/sync.war /usr/local/tomcat/webapps/sync.war
  cp -v /root/tomcat-users.xml /usr/local/tomcat/conf/
  if [ ! -e "/usr/local/tomcat/conf/server.xml.lock" ]; then
    sed -i -e 's/Connector port="8080"/Connector port="8080" URIEncoding="UTF-8"/' /usr/local/tomcat/conf/server.xml && touch /usr/local/tomcat/conf/server.xml.lock
  fi
  JAVA_OPTS="-server -Xms1500m -Xmx8G -Xmn450m -XX:MaxPermSize=256m -Dsolr.solr.home=/srv/data/papyri.info/solr" catalina.sh run
  exit 0
else
  echo "dispatch.war missing"
  exit 1
fi

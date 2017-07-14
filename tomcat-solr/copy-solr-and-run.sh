#!/bin/bash

if [ -e "/srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war" ]; then
  cp -v /srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war /usr/local/tomcat/webapps/dispatch.war
  cp -v /srv/data/papyri.info/git/navigator/pn-sync/target/sync.war /usr/local/tomcat/webapps/sync.war
  cp -v /root/solr.war /usr/local/tomcat/webapps/solr.war
  cp -v /root/tomcat-users.xml /usr/local/tomcat/conf/
  sed -i -e 's/Connector port="8080"/Connector port="8080" URIEncoding="UTF-8"/' /usr/local/tomcat/conf/server.xml
  JAVA_OPTS="-server -Xms1500m -Xmx2G -Xmn450m -XX:MaxPermSize=128m -verbose:gc -Xloggc:gc.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintHeapAtGC -XX:+UseConcMarkSweepGC -Dsolr.solr.home=/srv/data/papyri.info/solr" catalina.sh run
  exit 0
else
  exit 1
fi

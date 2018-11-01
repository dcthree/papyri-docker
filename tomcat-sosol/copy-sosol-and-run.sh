#!/bin/bash

if [ -e "/srv/data/papyri.info/sosol/editor/editor.war.lock" ]; then
  cp -v /srv/data/papyri.info/sosol/editor/editor.war /usr/local/tomcat/webapps/editor.war
  sed -i -e 's/Connector port="8080" protocol=/Connector port="8080" URIEncoding="UTF-8" protocol=/' /usr/local/tomcat/conf/server.xml
  # JAVA_OPTS="-server -Xms1500m -Xmx2G -Xmn450m -XX:MaxPermSize=128m -verbose:gc -Xloggc:gc.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintHeapAtGC -XX:+UseConcMarkSweepGC -Dsolr.solr.home=/srv/data/papyri.info/solr" catalina.sh run
  JAVA_OPTS="-server -Xms1500m -Xmx4G -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/srv/data/papyri.info/heap-dumps -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+CMSClassUnloadingEnabled -verbose:gc -Xloggc:gc.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintHeapAtGC -Djruby.objectspace.enabled=false -Djruby.thread.pool.enabled=true" catalina.sh run
  exit 0
else
  exit 1
fi

#!/bin/bash

if [ ! -d "/srv/data/papyri.info/git/navigator" ]; then
  mkdir -p /srv/data/papyri.info/git && cp -R /navigator /srv/data/papyri.info/git/navigator/
fi

if [ ! -d "/srv/data/papyri.info/solr" ]; then
  mkdir -p /srv/data/papyri.info && cp -R /navigator/pn-solr /srv/data/papyri.info/solr
fi

cd /srv/data/papyri.info/git/navigator/pn-dispatcher && mvn clean package
sed -i -e 's/litpap.info\/maven/dev.papyri.info\/maven/' /srv/data/papyri.info/git/navigator/pn-sync/pom.xml
sed -i -e 's/localhost:8083/localhost:8080/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/Publisher.java
sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
sed -i -e 's/mysql:\/\/localhost/mysql:\/\/mysql/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
cd /srv/data/papyri.info/git/navigator/pn-sync && mvn clean compile war:war

if [ ! -e "/srv/data/papyri.info/mapping_done" ]; then
  sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-mapping/src/info/papyri/map.clj
  cd /srv/data/papyri.info/git/navigator/pn-mapping && lein run map-all
  touch /srv/data/papyri.info/mapping_done
fi

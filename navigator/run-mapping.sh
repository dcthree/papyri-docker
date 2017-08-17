#!/bin/bash

if [ ! -d "/srv/data/papyri.info/git/navigator" ]; then
  mkdir -p /srv/data/papyri.info/git && cp -R /navigator /srv/data/papyri.info/git/navigator/
fi

if [ ! -d "/srv/data/papyri.info/solr" ]; then
  mkdir -p /srv/data/papyri.info && cp -R /navigator/pn-solr /srv/data/papyri.info/solr
fi

# dispatch
sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-dispatcher/src/main/java/info/papyri/dispatch/browse/CollectionBrowser.java
cp /root/dispatch-web.xml /srv/data/papyri.info/git/navigator/pn-dispatcher/src/main/webapp/WEB-INF/web.xml
cd /srv/data/papyri.info/git/navigator/pn-dispatcher && mvn clean package

# pn-sync
sed -i -e 's/litpap.info\/maven/dev.papyri.info\/maven/' /srv/data/papyri.info/git/navigator/pn-sync/pom.xml
sed -i -e 's/localhost:8083/localhost:8080/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/Publisher.java
sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
sed -i -e 's/mysql:\/\/localhost/mysql:\/\/mysql/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
sed -i -e 's/canonical/origin/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
sed -i -e 's/github/origin/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
sed -i -e 's/master/v1.0-rc1/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
sed -i -e '/^.*git\.push.*$/d' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
cd /srv/data/papyri.info/git/navigator/pn-sync && mvn clean compile war:war

if [ ! -e "/srv/data/papyri.info/pn/docs" ]; then
  mkdir -p /srv/data/papyri.info/pn
  git clone https://github.com/dclp/site-docs.git /srv/data/papyri.info/pn/docs
fi

if [ ! -e "/srv/data/papyri.info/mapping_done" ]; then
  sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-mapping/src/info/papyri/map.clj
  cd /srv/data/papyri.info/git/navigator/pn-mapping && lein run map-all && touch /srv/data/papyri.info/mapping_done
fi

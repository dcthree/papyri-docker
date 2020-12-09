#!/bin/bash

LOCK_PATH="/srv/data/papyri.info/lockfiles/navigator"
LOCK_FILE="${LOCK_PATH}/mapping_done.lock"

WAIT_LOCK="/srv/data/papyri.info/lockfiles/repo_clone/canonical_cloned.lock"

echo "waiting for ${WAIT_LOCK}"
until [ -e "${WAIT_LOCK}" ]; do
  sleep 1
done
echo "${WAIT_LOCK} detected"

if [ ! -d "/srv/data/papyri.info/git/navigator" ]; then
  mkdir -p /srv/data/papyri.info/git && cp -R /navigator /srv/data/papyri.info/git/navigator/
fi

if [ ! -e "/solr/solr.xml" ]; then
  cp -R -v /navigator/pn-solr/. /solr/
  find /solr/ -type d -exec chmod a+x {} \;
  chmod -Rv a+rw /solr/
  touch /solr/solr.xml.lock
fi

# pn-config
sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-config/pi.conf

# pn-search
sed -i -e 's/localhost:8983/solr:8983/' /solr/pn-search/conf/xslt/example_atom.xsl
sed -i -e 's/localhost:8983/solr:8983/' /solr/pn-search/conf/xslt/example_rss.xsl
# sed -i -e 's/solr_hostname=localhost/solr_hostname=solr/' /srv/data/papyri.info/git/navigator/pn-solr/pn-search/conf/scripts.conf

# dispatch
if [ ! -e "/srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war" ]; then
  echo "building dispatch.war"
  sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-dispatcher/src/main/java/info/papyri/dispatch/browse/CollectionBrowser.java
  # cp /root/dispatch-web.xml /srv/data/papyri.info/git/navigator/pn-dispatcher/src/main/webapp/WEB-INF/web.xml
  sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-dispatcher/src/main/webapp/WEB-INF/web.xml
  sed -i -e 's/localhost:8983/solr:8983/' /srv/data/papyri.info/git/navigator/pn-dispatcher/src/main/webapp/WEB-INF/web.xml
  sed -i -e 's/localhost:8983/solr:8983/' /srv/data/papyri.info/git/navigator/pn-dispatcher/src/test/java/info/papyri/dispatch/browse/facet/StringSearchFacetIT.java
  cd /srv/data/papyri.info/git/navigator/pn-dispatcher && git revert -n c9d4e5c && mvn clean package
else
  echo "dispatch.war already built, skipping"
fi

# pn-sync
if [ ! -e "/srv/data/papyri.info/git/navigator/pn-sync/target/sync.war" ]; then
  echo "building sync.war"
  sed -i -e 's/litpap.info\/maven/dev.papyri.info\/maven/' /srv/data/papyri.info/git/navigator/pn-sync/pom.xml
  sed -i -e 's/localhost:8983/solr:8983/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/Publisher.java
  sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
  sed -i -e 's/mysql:\/\/localhost/mysql:\/\/mysql/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
  sed -i -e 's/canonical/origin/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
  sed -i -e 's/github/origin/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
  sed -i -e 's/master/v1.0-rc1/' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
  sed -i -e '/^.*git\.push.*$/d' /srv/data/papyri.info/git/navigator/pn-sync/src/main/java/info/papyri/sync/GitWrapper.java
  cd /srv/data/papyri.info/git/navigator/pn-sync && mvn clean compile war:war
else
  echo "sync.war already built, skipping"
fi

if [ ! -e "/srv/data/papyri.info/pn/docs" ]; then
  mkdir -p /srv/data/papyri.info/pn
  git clone https://github.com/dclp/site-docs.git /srv/data/papyri.info/pn/docs
fi

if [ ! -e "$LOCK_FILE" ]; then
  mkdir -p $LOCK_PATH
  sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-mapping/src/info/papyri/map.clj
  cd /srv/data/papyri.info/git/navigator/pn-mapping && lein run map-all && touch $LOCK_FILE
  echo "mapping done"
else
  echo "$LOCK_FILE already exists, skipping mapping"
fi

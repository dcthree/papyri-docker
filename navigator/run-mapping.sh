#!/bin/bash

if [ ! -d "/srv/data/papyri.info/git/navigator" ]; then
  mkdir -p /srv/data/papyri.info/git && cp -R /navigator /srv/data/papyri.info/git/navigator/
fi

sed -i -e 's/localhost:8090/fuseki:8090/' /srv/data/papyri.info/git/navigator/pn-mapping/src/info/papyri/map.clj
cd /srv/data/papyri.info/git/navigator/pn-mapping && lein run map-all
cd /srv/data/papyri.info/git/navigator/pn-dispatcher && mvn clean package

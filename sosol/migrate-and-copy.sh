#!/bin/bash

WAIT_LOCK="/srv/data/papyri.info/lockfiles/repo_clone/canonical_cloned.lock"
echo "waiting for ${WAIT_LOCK}"
until [ -e "${WAIT_LOCK}" ]; do
  sleep 1
done
echo "${WAIT_LOCK} detected"

if [ ! -e "/srv/data/papyri.info/sosol/editor/editor.war.lock" ]; then
  echo "editor.war.lock missing, generating editor.war"
  rm -fv /srv/data/papyri.info/sosol/editor/editor.war
  ./wait-for-it.sh -t 9999 mysql:3306
  rm -rf /srv/data/papyri.info/sosol/editor
  mkdir -p /srv/data/papyri.info/sosol
  sed -i -e "s/NUMBERS_SERVER_DOMAIN = 'papyri.info'/NUMBERS_SERVER_DOMAIN = 'httpd'/" /root/sosol/lib/numbers_rdf.rb
  cp -R /root/sosol /srv/data/papyri.info/sosol/editor
  cd /srv/data/papyri.info/sosol/editor && bundle exec rake db:migrate RAILS_ENV="production"
  cd /srv/data/papyri.info/sosol/editor && bundle exec warble war && touch editor.war.lock
else
  echo "editor.war.lock found, skipping generating editor.war"
fi

echo "done building editor.war"
exit 0

#!/bin/bash

WAIT_LOCK="/srv/data/papyri.info/lockfiles/repo_clone/canonical_cloned.lock"
echo "waiting for ${WAIT_LOCK}"
until [ -e "${WAIT_LOCK}" ]; do
  sleep 1
done
echo "${WAIT_LOCK} detected"

if true; then # [ ! -e "/srv/data/papyri.info/sosol/editor/editor.war.lock" ]; then
  echo "generating editor.war"
  rm -fv /srv/data/papyri.info/sosol/editor/editor.war /srv/data/papyri.info/sosol/editor/editor.war.lock
  /opt/sosol-compose/wait-for-it.sh -t 9999 mysql:3306
  rm -rf /srv/data/papyri.info/sosol/editor
  mkdir -p /srv/data/papyri.info/sosol
  sed -i -e "s/NUMBERS_SERVER_DOMAIN = 'papyri.info'/NUMBERS_SERVER_DOMAIN = 'httpd'/" /root/sosol/lib/numbers_rdf.rb
  cp -R /root/sosol /srv/data/papyri.info/sosol/editor
  cp -Rv /opt/sosol-compose/config/* /srv/data/papyri.info/sosol/editor/config
  echo "Capistrano"
  cd /srv/data/papyri.info/sosol/editor && bundle exec cap local externals:setup
  echo "Assets (RAILS_RELATIVE_URL_ROOT)"
  cd /srv/data/papyri.info/sosol/editor && RAILS_RELATIVE_URL_ROOT='/editor' RAILS_ENV=production RAILS_GROUPS=assets bundle exec rake assets:precompile
  ls /srv/data/papyri.info/sosol/editor/public
  echo "Migrate"
  cd /srv/data/papyri.info/sosol/editor && bundle exec rake db:migrate RAILS_ENV="production"
  echo "Warble"
  cd /srv/data/papyri.info/sosol/editor && bundle exec warble war && touch editor.war.lock
else
  echo "editor.war.lock found, skipping generating editor.war"
fi

echo "done building editor.war"
exit 0

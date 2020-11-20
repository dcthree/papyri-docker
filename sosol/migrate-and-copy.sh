#!/bin/bash

if true; then # [ ! -e "/srv/data/papyri.info/sosol/editor/editor.war" ]; then
  rm -fv /srv/data/papyri.info/sosol/editor/editor.war.lock
  ./wait-for-it.sh -t 9999 mysql:3306
  rm -rf /srv/data/papyri.info/sosol/editor
  mkdir -p /srv/data/papyri.info/sosol
  sed -i -e "s/NUMBERS_SERVER_DOMAIN = 'papyri.info'/NUMBERS_SERVER_DOMAIN = 'httpd'/" /root/sosol/lib/numbers_rdf.rb
  cp -R /root/sosol /srv/data/papyri.info/sosol/editor
  cd /srv/data/papyri.info/sosol/editor && bundle exec rake db:migrate RAILS_ENV="production"
  cd /srv/data/papyri.info/sosol/editor && bundle exec warble war && touch editor.war.lock
else
  cd /srv/data/papyri.info/sosol/editor && bundle exec rake db:migrate RAILS_ENV="production"
fi

echo "sleep infinity"
sleep infinity

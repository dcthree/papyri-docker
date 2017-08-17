#!/bin/bash

if [ ! -e "/srv/data/papyri.info/sosol/editor/editor.war" ]; then
  ./wait-for-it.sh -t 9999 mysql:3306
  rm -rf /srv/data/papyri.info/sosol/editor
  mkdir -p /srv/data/papyri.info/sosol
  cp -R /root/sosol /srv/data/papyri.info/sosol/editor
  cd /srv/data/papyri.info/sosol/editor && bundle exec rake db:migrate RAILS_ENV="production"
  cd /srv/data/papyri.info/sosol/editor && bundle exec warble war
fi

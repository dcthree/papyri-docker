#!/bin/bash

WAIT_LOCK="/srv/data/papyri.info/lockfiles/repo_clone/canonical_cloned.lock"
echo "waiting for ${WAIT_LOCK}"
until [ -e "${WAIT_LOCK}" ]; do
  sleep 1
done
echo "${WAIT_LOCK} detected"

if true; then # [ ! -e "/srv/data/papyri.info/sosol/editor/editor.war.lock" ]; then
  /opt/sosol-compose/wait-for-it.sh -t 9999 postgres:5432
  rm -rf /srv/data/papyri.info/sosol/editor
  mkdir -p /srv/data/papyri.info/sosol
  sed -i -e "s/NUMBERS_SERVER_DOMAIN = 'papyri.info'/NUMBERS_SERVER_DOMAIN = 'httpd'/" /root/sosol/lib/numbers_rdf.rb
  cp -R /root/sosol /srv/data/papyri.info/sosol/editor
  cp -Rv /opt/sosol-compose/config/* /srv/data/papyri.info/sosol/editor/config
  echo "Capistrano"
  cd /srv/data/papyri.info/sosol/editor && bundle exec cap local externals:setup
  echo "Assets (RAILS_RELATIVE_URL_ROOT)"
  cd /srv/data/papyri.info/sosol/editor && RAILS_RELATIVE_URL_ROOT='/editor' RAILS_ENV=production RAILS_GROUPS=assets bundle exec rake assets:precompile
  echo "Migrate"
  cd /srv/data/papyri.info/sosol/editor && bundle exec rake db:migrate RAILS_ENV="production"
  echo "Puma"
  RAILS_RELATIVE_URL_ROOT='/editor' RAILS_ENV=production start-stop-daemon --start --quiet --oknodo --chdir /srv/data/papyri.info/sosol/editor --pidfile /tmp/puma.pid --background --exec "$(which bundle)" -- exec rails server -b 0.0.0.0 -p 8080
  echo "Rails server daemon started"
  touch /srv/data/papyri.info/sosol/editor/log/production.log
  tail -f /srv/data/papyri.info/sosol/editor/log/production.log
fi

exit 0

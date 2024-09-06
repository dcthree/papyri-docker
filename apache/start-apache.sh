#!/bin/bash

/root/wait-for-it.sh -t 9999 xsugar:8080
/root/wait-for-it.sh -t 9999 fuseki:8090
/root/wait-for-it.sh -t 9999 sosol:8080
/root/wait-for-it.sh -t 99999 tomcat-pn:8080

WAIT_FILE="/srv/data/papyri.info/git/navigator/pn-config/pi.conf"
echo "waiting for ${WAIT_FILE}"
until [ -e "$WAIT_FILE" ]; do
  sleep 1
done
echo "${WAIT_FILE} detected"

sed -i -e '/^ *AllowOverride None/d' /usr/local/apache2/conf/httpd.conf
sed -i -e '/^ *Order .*/d' /usr/local/apache2/conf/httpd.conf
sed -i -e '/^ *Deny .*/d' /usr/local/apache2/conf/httpd.conf
sed -i -e '/^DocumentRoot /d' /usr/local/apache2/conf/httpd.conf

# Apache 2.4:
# echo "LoadModule proxy_module modules/mod_proxy.so" >> /usr/local/apache2/conf/httpd.conf
# echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /usr/local/apache2/conf/httpd.conf
# echo "LoadModule log_config_module modules/mod_log_config.so" >> /usr/local/apache2/conf/httpd.conf
# echo "LoadModule headers_module modules/mod_headers.so" >> /usr/local/apache2/conf/httpd.conf
# echo "LoadModule alias_module modules/mod_alias.so" >> /usr/local/apache2/conf/httpd.conf

if true; then # [ ! -e "/usr/local/apache2/conf/httpd.conf.lock" ]; then
  echo "Updating httpd.conf..."
  rm -f /usr/local/apache2/conf/httpd.conf.lock
  cat /root/default_httpd.conf /srv/data/papyri.info/git/navigator/pn-config/pi.conf > /usr/local/apache2/conf/httpd.conf
  sed -i -e 's/localhost:8090/fuseki:8090/g' /usr/local/apache2/conf/httpd.conf
  sed -i -e 's/localhost:8083/tomcat-pn:8080/g' /usr/local/apache2/conf/httpd.conf
  # sed -i -e 's/localhost:8082/sosol:3000/g' /usr/local/apache2/conf/httpd.conf
  sed -i -e 's/localhost:8082/sosol:8080/g' /usr/local/apache2/conf/httpd.conf
  sed -i -e 's/localhost:9999/xsugar:8080/g' /usr/local/apache2/conf/httpd.conf
  sed -i -e '/^ServerName.*$/d' /usr/local/apache2/conf/httpd.conf
  sed -i -e '/^ServerAlias.*$/d' /usr/local/apache2/conf/httpd.conf
  touch /usr/local/apache2/conf/httpd.conf.lock
else
  echo "httpd.conf already updated, skipping updates"
fi

# needs pn-sync run once
# sed -i -e '/^RewriteRule...index.html.*/d' /usr/local/apache2/conf/httpd.conf

# sed -i -e '/^ErrorLog.*$/d' /usr/local/apache2/conf/httpd.conf
# sed -i -e '/^CustomLog.*$/d' /usr/local/apache2/conf/httpd.conf
# sed -i -e '/^RewriteLog/d' /usr/local/apache2/conf/httpd.conf
mkdir -p /var/log/httpd && chmod a+w /var/log/httpd
# if [ ! -e /srv/data/papyri.info/pn/home ]; then
rm -rfv /srv/data/papyri.info/pn/home
mkdir -p /srv/data/papyri.info/pn
cp -rv /srv/data/papyri.info/git/navigator/pn-site /srv/data/papyri.info/pn/home
# fi
chmod -R a+r /srv/data
cat /usr/local/apache2/conf/httpd.conf

httpd-foreground

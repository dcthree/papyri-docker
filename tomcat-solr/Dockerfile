FROM tomcat:7

RUN apt-get update && apt-get install -y git mysql-client && rm -rf /var/lib/apt/lists/*

ADD . /root
CMD /root/copy-solr-and-run.sh

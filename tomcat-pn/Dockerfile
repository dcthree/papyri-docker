FROM tomcat:9-jdk11

# RUN apt-get update && apt-get install -y git default-mysql-client && rm -rf /var/lib/apt/lists/*

ADD . /root
CMD /root/copy-solr-and-run.sh

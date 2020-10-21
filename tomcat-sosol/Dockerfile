FROM tomcat:7

RUN apt-get update && apt-get install -y git default-mysql-client && rm -rf /var/lib/apt/lists/*

ADD . /root
CMD /root/copy-sosol-and-run.sh

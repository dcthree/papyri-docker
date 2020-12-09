FROM httpd:2.2

ADD . /root/
RUN chmod a+x /root/start-apache.sh /root/wait-for-it.sh
CMD /root/start-apache.sh

# TODO: 'latest' is OK for development, for production...
FROM breed85/oracle-12c:latest

# download, install, cleanup
RUN yum -y install wget \
&& cd /tmp \
&& wget http://192.168.2.111:8000/linuxamd64_12102_database_1of2.zip \
&& wget http://192.168.2.111:8000/linuxamd64_12102_database_2of2.zip \
&& wget -qO- http://192.168.2.111:8000/setup.sh | sh \
&& rm -f /tmp/linuxamd64_12102_database_?of2.zip

# TODO...
# expose TNS port
EXPOSE 1521

# TODO: Final entry point
CMD echo Hello Oracle12c...
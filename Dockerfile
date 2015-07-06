# TODO: 'latest' is ok for development, for production...
FROM breed85/oracle-12c:latest

# Install Oracle 12c

# TODO: adjust scripts and remove hardcoded '/vagrant'
COPY files /vagrant

RUN /vagrant/scripts/setup.sh

# expose TNS port
EXPOSE 1521

# Final entry point
CMD echo Hello Oracle12c...
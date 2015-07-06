# TODO: 'latest' is ok for development, for production...
FROM breed85/oracle-12c:latest

# Install Oracle 12c

# TODO/NOTE: We assume mounting host volume here???
#COPY *.zip setup.sh ./
COPY setup.sh ./

# TODO: adjust scripts and remove hardcoded '/vagrant'
# TODO: Use WORKDIR here
RUN ./setup.sh

# expose TNS port
EXPOSE 1521

# Final entry point
CMD echo Hello Oracle12c...
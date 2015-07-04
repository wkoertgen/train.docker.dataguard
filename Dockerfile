# TODO: 'latest' is ok for development, for production...
FROM breed85/oracle-12c:latest

# TODO: Install Oracle 12c
# RUN echo Installing...

# expose TNS port
EXPOSE 1521

# Final entry point
CMD echo Hello Oracle12c...
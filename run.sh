docker run -it --name="oracle12c" \
-v $PWD/install:/tmp \
-w /tmp \
breed85/oracle-12c \
/bin/bash -ci ./setup.sh
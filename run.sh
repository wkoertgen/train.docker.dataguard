docker run -it --name="oracle12c" \
-v $PWD/install:/tmp \
-w /tmp \
oraclelinux:7.1 \
/bin/bash -ci ./setup.sh
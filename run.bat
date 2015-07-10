@echo off
setlocal
set image=breed85/oracle-12c
set cmd=/bin/bash -ci ./setup.sh
set tmpPath=%~d0\%~p0install
set tmpPath=%tmpPath:\=/%
docker run -it --name="oracle12c" -v "%tmpPath%:/tmp" -w /tmp %image% %cmd%
endlocal

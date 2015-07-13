@echo off
setlocal
set image=oraclelinux:7.1
set cmd=/bin/bash -ci ./setup.sh
set tmpPath=%~d0%~p0install
set tmpPath=%tmpPath::=%
set tmpPath=//%tmpPath:\=/%

rem for /F "usebackq" %%a in (`docker ps -a -q`) do docker rm -f %%a

docker run -it --name="oracle12c" -v "%tmpPath%:/tmp" -w /tmp %image% %cmd%
endlocal

#!/usr/bin/env bash

cd ~/Git/FreeTubeAndroid/dist/web
http-server --port 8081 &
serverPID=$(echo $!)
firefoxpwa site launch 01HWJSJ6M6286AT67MAAHACYX1 %u
firefoxPID=$(ps -af -o pid,args | awk '/[0]1HWJSJ6M6286AT67MAAHACYX1/{print $1}')
strace -ewrite -p $firefoxPID
kill -s SIGINT $serverPID
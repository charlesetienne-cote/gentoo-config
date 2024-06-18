#!/usr/bin/env bash

cd ~/Git/Hyperpipe/dist
http-server --cors --port 8082 &
serverPID=$(echo $!)
firefoxpwa site launch 01HWRZKY8MCPZXAZGKW1NPTJCC %u
firefoxPID=$(ps -af -o pid,args | awk '/[0]1HWRZKY8MCPZXAZGKW1NPTJCC/{print $1}')
strace -ewrite -p $firefoxPID
kill -s SIGINT $serverPID
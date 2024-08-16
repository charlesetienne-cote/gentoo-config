cd ~/Git/FreeTubeAndroid/dist/web
http-server --port 8081 &
if [ ! -f "/tmp/indexeddb.js" ]; then
		cd /tmp
		wget --output-document="indexeddb.js" https://raw.githubusercontent.com/Polarisation/indexeddb-export-import/master/index.js
fi
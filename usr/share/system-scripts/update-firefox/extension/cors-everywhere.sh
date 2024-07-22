if [ ! -f "$FIREFOXPROFILEPATH/extensions/cors-everywhere@spenibus.xpi" ]; then
	cd /tmp
	if [ ! -d "/tmp/cors-everywhere-firefox-addon-master" ]; then
		wget --output-document="cors-everywhere.zip" https://codeload.github.com/spenibus/cors-everywhere-firefox-addon/zip/refs/heads/master
		unzip -q cors-everywhere.zip
	fi
	cd /tmp/cors-everywhere-firefox-addon-master
	rm -rf _test
	zip -q -r "$FIREFOXPROFILEPATH/extensions/cors-everywhere@spenibus.xpi" *
fi